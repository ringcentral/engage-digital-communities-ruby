module Dimelo
  module API
    class Error < StandardError
      attr_accessor :original_exception

      # Public : Return specific Exceptions if defined
      #
      # Returns :
      # - specific exception (DomainNotFoundError,...) if status & name matches declared Error
      # - BaseError if status and name does not match any declared Error
      # - Error if body cannot be parsed
      def self.from(body)
        json = Dimelo::API.decode_json(body).symbolize_keys!
        name = json.delete(:error)
        status = json.delete(:status)
        message = json.delete(:message)

        if klass = BaseError.descendants.find { |error| error.status == status && error.name == name}
          klass.new(name, status, message)
        else
          BaseError.new(name, status, message)
        end
      rescue MultiJson::LoadError
        new(body)
      end
    end

    class BaseError < StandardError
      class_attribute :status, :name

      def initialize(name, status, message='')
        @name = name
        @status = status
        @message = message
      end
    end

    class DomainNotFoundError < BaseError
      self.status = 404
      self.name = 'domain_not_found'
    end

    class InvalidAccessTokenError < BaseError
      self.status = 403
      self.name = 'invalid_access_token'
    end

    class InvalidUserTypeError < BaseError #happens only on POST /users
      self.status = 400
      self.name = 'invalid_user_type'
    end

    class NotEnabledError < BaseError
      self.status = 403
      self.name = 'api_not_enabled'
    end

    class NotFoundError < BaseError
      self.status = 404
      self.name = 'not_found'
    end

    class SslError < BaseError
      self.status = 412
      self.name = 'routing_error'
    end
  end
end