module Dimelo
  module API
    class Model  
      
      class << self
        
        def path(*args)
          @path = args.first if args.any?
          @path
        end
        
        def attribute(arg)
          @attributes ||= []
          @attributes << arg
          define_method arg do
            @_values[arg.to_s]
          end
          define_method "#{arg}=" do |value|
            @_values[arg.to_s] = value
          end
        end
        
        def attributes(*args)
          args.each do |arg|
            attribute arg
          end
        end
        
        def submit_attributes(*args)
          @submit_attributes = args if args.any?
          @submit_attributes ||= []
        end
        
        def find(*args)
          client = args.pop
          criterias = args.pop
          criterias = {:id => criterias} unless criterias.is_a?(Hash)
          parse(client.transport(:get, compute_path(criterias), {:query => criterias}), client)
        end
        
        def parse(document, client=nil)
          object = Dimelo::API.decode_json(document)
          object.is_a?(Array) ? object.map{ |i| new(i, client) } : new(object, client)
        end
        
        # Inspired by https://github.com/svenfuchs/i18n/blob/master/lib/i18n/core_ext/string/interpolate.rb
        INTERPOLATION_PATTERN = /%\{(\w+)\}/ # matches placeholders like "%{foo}"
        def compute_path(criterias={})
          path.gsub(INTERPOLATION_PATTERN) do |match|
            criterias.delete($1.to_sym) || ''
          end
        end
        
      end
      
      attr_accessor :client
      
      delegate :compute_path, :to => 'self.class'
      
      def initialize(hash={}, client=nil)
        @_values = {}
        self.client = client
        hash.each do |k,v|
          self.send("#{k}=", v)
        end
      end
      
      def attributes
        @_values
      end
      
      def reload
        raise ArgumentError.new("You cannot fetch models without a populated id attribute") if id.nil?
        other = self.class.find(id, client)
        self.attributes.merge!(other.attributes) if other
        self
      end
      
      def ==(other)
        other.is_a?(self.class) and self.id == other.id and self.id.present?
      end
      
    end
  end
end