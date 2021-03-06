require 'net/https'

module Dimelo::CCP
  module API
    class Connection

      class << self

        def from_uri(uri, options = {})
          options.merge!(:use_ssl => uri.scheme == 'https')
          pool[uri_key(uri)] ||= new(uri.to_s, options)
        end

        private

        def uri_key(uri)
          "#{uri.scheme}://#{uri.host}:#{uri.port}"
        end

        def pool
          @pool ||= {}
        end

      end

      def initialize(url, options={})
        @url = url
        @http_options = options
        initialize_client
      end

      def perform(method, uri, payload = {})
        access_token = payload.delete(:access_token)
        @client.send(method, uri, payload) do |req|
          req.headers[:accept] = 'application/json'
          req.headers[:authorization] = "Bearer #{access_token}"
          req.headers[:user_agent] = user_agent
        end
      end

      private

      def timeout
        @http_options[:timeout] || 10
      end

      def user_agent_details
        strip_non_ascii(@http_options[:user_agent] || '')
      end

      def strip_non_ascii(setting, replacement = '')
        setting.gsub(/\P{ASCII}/, replacement)
      end

      def user_agent
        "DimeloAPI/#{Dimelo::CCP::API::VERSION} " \
          << (user_agent_details.present? ? "(#{user_agent_details}) " : '') \
          << "Faraday/#{Faraday::VERSION} " \
          << "Ruby/#{RUBY_VERSION}"
      end

      def client_options
        {}.tap do |opts|
          opts[:request] = request_options
          opts[:ssl] = ssl_options if @http_options[:use_ssl]
        end
      end

      def request_options
        { timeout: timeout, open_timeout: timeout }
      end

      def ssl_options
        { verify_mode: OpenSSL::SSL::VERIFY_NONE, verify_depth: 5 }
      end

      def initialize_client
        @client = Faraday.new(@url, client_options) do |faraday|
          faraday.request :multipart
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter #adapter should be last in the list https://github.com/lostisland/faraday/issues/161
        end
      end

    end

  end
end
