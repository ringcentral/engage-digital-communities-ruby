module Dimelo
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
        Dimelo::API.decode_json(transport(:get, 'check'))
      end

      def config
        Dimelo::API.decode_json(transport(:get, 'config'))
      end

      def webhooks
        Dimelo::API.decode_json(transport(:get, 'webhooks'))
      end

      def webhook_api_setup!(url, preprod = true, verify_token = nil, events_name = [])
        return unless url && verify_token
        webhook = webhooks.find { |webhook| webhook['endpoint_url'] == url }
        return if webhook && events_name.all? { |e| webhook[e] == true }

        transport(:delete, "webhooks/#{webhook['id']}") if webhook && webhook.has_key?('id')
        transport(:post, 'webhooks', {
          'endpoint_enabled' => true,
          'endpoint_url' => url,
          'preprod_settings' => preprod,
          'verify_token' => verify_token
        }.merge(Hash[events_name.map { |e| [e, true] }]))
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
