module Dimelo
  module API
    
    class << self
      
      def decode_json(document)
        ActiveSupport::JSON.decode(document)
      end
      
      def encode_json(object)
        ActiveSupport::JSON.encode(object)
      end
      
    end
    
  end
end