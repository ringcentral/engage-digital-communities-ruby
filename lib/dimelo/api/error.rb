module Dimelo
  module API
    class Error < StandardError
      attr_accessor :original_exception

      # Public : Return specific Exceptions if defined
      #
      # Returns :
      # - DefinedError descendant exception (DomainNotFoundError,...) if status & name matches declared DefinedError child
      # - BaseError if status and name does not match any declared Error
      # - Error if body cannot be json parsed
      def self.from(body)
        json = Dimelo::API.decode_json(body).symbolize_keys!
        name = json.delete(:error)
        status = json.delete(:status)
        message = json.delete(:message)

        if klass = DefinedError.descendants.find { |error| error.status == status && error.name == name}
          klass.new
        else
          BaseError.new(name, status, message)
        end
      rescue ::MultiJson::LoadError
        new(body)
      end
    end

    class BaseError < StandardError
      def initialize(name, status, message='')
        @name = name
        @status = status
        @message = message
        super(message)
      end
    end

    class DefinedError < StandardError
      class_attribute :status, :name
    end

    class DomainNotFoundError < DefinedError
      self.status = 404
      self.name = 'domain_not_found'
    end

    class InvalidAccessTokenError < DefinedError
      self.status = 403
      self.name = 'invalid_access_token'
    end

    class InvalidUserTypeError < DefinedError #happens only on POST /users
      self.status = 400
      self.name = 'invalid_user_type'
    end

    class NotEnabledError < DefinedError
      self.status = 403
      self.name = 'api_not_enabled'
    end

    class NotFoundError < DefinedError
      self.status = 404
      self.name = 'not_found'
    end

    class SslError < DefinedError
      self.status = 412
      self.name = 'routing_error'
    end
  end
end