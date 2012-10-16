require 'net/https'
module Dimelo
  module API

    class Error < StandardError
      attr_accessor :original_exception
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

      def transport(method, path, params={})
        response = connection.perform(request(method, path, params))
        response.value
        response.body
      rescue Net::HTTPExceptions => e
        raise Error.new("#{method.to_s.upcase} #{path} - #{response.code} #{response.body}").tap{ |exc| exc.original_exception = e }
      end

      def request(method, path, params)
        request_class = Net::HTTP.const_get(method.to_s.camelize)
        request_class.new(request_uri(path, params)).tap do |request|
          request.body = request_body(params[:body])
        end
      end

      private

      def request_uri(path, params)
        @base_uri.dup.tap do |uri|
          uri.path = File.join(uri.path, path).chomp('/')
          uri.query = @default_parameters.merge((params[:query] || {})).to_query
        end.request_uri
      end

      def request_body(body)
        body.is_a?(Hash) ? body.to_query : body.to_s
      end

      def connection
        @connection ||= Connection.from_uri(@base_uri, @http_options)
      end

    end
  end
end
