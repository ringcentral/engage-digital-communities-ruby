module Dimelo::CCP
  module API
    class Client

      attr_accessor :base_uri, :default_parameters

      def initialize(base_uri, options={})
        @base_uri = base_uri.is_a?(URI) ? base_uri : URI.parse(base_uri)
        options = options.with_indifferent_access
        @http_options = options.delete(:http_options) || {}
        @default_parameters = options
      end

      def check
        Dimelo::CCP::API.decode_json(transport(:get, 'check'))
      end

      def config
        Dimelo::CCP::API.decode_json(transport(:get, 'config'))
      end

      def transport(method, path, payload={})
        response = connection.perform(method, path, default_parameters.merge(payload))

        if response.success? or response.status == 422
          response.body
        else
          raise Error.from(method, path, response.status, response.body)
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
