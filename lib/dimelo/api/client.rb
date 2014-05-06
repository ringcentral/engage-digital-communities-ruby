module Dimelo
  module API

    class Error < StandardError
      attr_accessor :original_exception
      class_attribute :status, :name

      def initialize(name, status, message)
        @name = name
        @status = status
        @message = message
      end

      def self.from(attrs={})
        attrs.symbolize_keys!
        name = attrs.delete(:error)
        status = attrs.delete(:status)
        message = attrs.delete(:message)

        if klass = descendants.find { |error| error.status == status && error.name == name}
          klass.new(name, status, message)
        else
          new(name, status, message)
        end
      end
    end

    class DomainNotFoundError < Error
      self.status = 404
      self.name = 'domain_not_found'
    end

    class InvalidAccessTokenError < Error
      self.status = 403
      self.name = 'invalid_access_token'
    end

    class InvalidUserTypeError < Error #happens only on POST /users
      self.status = 400
      self.name = 'invalid_user_type'
    end

    class NotEnabledError < Error
      self.status = 403
      self.name = 'api_not_enabled'
    end

    class NotFoundError < Error
      self.status = 404
      self.name = 'not_found'
    end

    class SslError < Error
      self.status = 412
      self.name = 'routing_error'
    end

    class Client

      attr_accessor :base_uri, :default_parameters

      def initialize(base_uri, options={})
        @base_uri = base_uri.is_a?(URI) ? base_uri : URI.parse(base_uri)
        options = options.with_indifferent_access
        @http_options = options.delete(:http_options) || {}
        @default_parameters = options
      end

      def check
        Dimelo::API.decode_json(transport(:get, 'check'))
      end

      def config
        Dimelo::API.decode_json(transport(:get, 'config'))
      end

      def transport(method, path, payload={})
        response = connection.perform(method, path, default_parameters.merge(payload))

        if response.success?
          response.body
        else
          raise Error.from(Dimelo::API.decode_json(response.body))
        end
      end

      private

      def request_uri(path, params)
        @base_uri.dup.tap do |uri|
          uri.path = File.join(uri.path, path).chomp('/')
        end.request_uri
      end

      def connection
        @connection ||= Connection.from_uri(@base_uri, @http_options)
      end

    end
  end
end
