require 'active_support/core_ext/string'
require 'active_support/core_ext/object'
require 'uri'
require 'net/http'

module Dimelo
  module API
    class Transport
      
      attr_accessor :base_uri, :default_parameters
      
      def initialize(base_uri, default_parameters={})
        @base_uri = base_uri.is_a?(URI) ? base_uri : URI.parse(base_uri)
        @default_parameters = default_parameters
      end
      
      def transport(method, path, params={})
        connection.perform(request(method, path, params))
      end
      
      def request(method, path, params)
        request_class = Net::HTTP.const_get(method.to_s.camelize)
        request_class.new(absolute_uri(path, params)).tap do |request|
          request.body = request_body(params[:body])
        end
      end
      
      private
      
      def absolute_uri(path, params)
        @base_uri.dup.tap do |uri|
          uri.path = File.join(uri.path, path)
          uri.query = @default_parameters.merge((params[:query] || {})).to_query
        end.to_s
      end
      
      def request_body(body)
        body.is_a?(Hash) ? body.to_query : body.to_s
      end
      
      def connection
        @connection ||= Connection.from_uri(@base_uri)
      end
      
    end
  end
end