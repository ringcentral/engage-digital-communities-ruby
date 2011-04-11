require 'net/http'
require 'net/https'

module Dimelo
  module API
    class Connection
      
      class << self
        
        def from_uri(uri)
          pool[uri_key(uri)] ||= new(uri.host, uri.port, :use_ssl => uri.scheme == 'https')
        end
        
        private
        
        def uri_key(uri)
          "#{uri.scheme}://#{uri.host}:#{uri.port}"
        end
        
        def pool
          @pool ||= {}
        end
        
      end
      
      def initialize(host, port, options={})
        @occupied = false
        @host = host
        @port = port
        @http_options = options
        initialize_client
      end
  
      def perform(request, retry_count=0)
        start
        response = nil
        begin
          response = @client.request(request)
          return response
        ensure
          unless response && @client.send(:keep_alive?, request, response)
            @client.finish if @client.started?
          end
        end
      rescue Net::HTTPError, SystemCallError, TimeoutError, OpenSSL::SSL::SSLError, EOFError => e
        retry_count -= 1
        initialize_client
        retry if retry_count >= 0
      end
  
      private
  
      def start
        @client.start unless @client.started?
      end
  
      def initialize_client
        @client = Net::HTTP.new(@host, @port)
        @client.read_timeout = @http_options[:timeout] || 10
        @client.open_timeout = @http_options[:timeout] || 10
        @client.close_on_empty_response = false

        if @client.use_ssl = @http_options[:use_ssl]
          @client.verify_mode = OpenSSL::SSL::VERIFY_NONE
          @client.verify_depth = 5
        end
      end
    
    end
    
  end
end