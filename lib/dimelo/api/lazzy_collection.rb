module Dimelo
  module API
    
    class LazzyCollection < BasicObject
      
      include Enumerable
      
      class << self
        
        def new(params, &block)
          if (params.has_key?(:offset) || params.has_key?('offset'))
            yield params
          else
            instance = super(params, &block)
            instance.paginator.first.is_a?(Enumerable) ? instance : instance.paginator.first
          end
        end
        
      end
      
      attr_reader :paginator
      
      def initialize(params={}, &block)
        @paginator = Paginator.new(params, &block)
      end
      
      def [](index)
        paginator.get_item_at(index)
      end
      
      def to_a
        @to_a ||= each
      end
      alias :to_ary :to_a
      
      def respond_to?(method)
        super || Array.public_instance_methods.include?(method.to_s)
      end
      
      def each(&block)
        index = 0
        while true
          item = paginator.get_item_at(index)
          break if item.nil?
          yield item if block.present?
          index += 1
        end
        paginator.flatten
      end
      
      def inspect
        "<Dimelo::API::LazzyCollection instance>"
      end
      
      protected
      
      # /!\ Fetch all API, please avoid this behavior
      def method_missing(name, *args, &block)
        super unless respond_to?(name)
        warn %{WARNING: Method '#{name}` called on LazzyCollection object from #{Kernel.caller.first}.
  All API items might be fetched, so please verify that you are a consenting adult.}
        self.to_a.send(name, *args, &block)
      end
      
      def warn(message)
        defined?(Rails) ? Rails.logger.warn(message) : STDERR.puts(message)
      end
      
      class Paginator
        
        DEFAULT_PAGE_SIZE = 30
        
        attr_reader :page_cache
        
        def initialize(params, &block)
          @params = params.dup
          @block = block
          @page_cache = []
        end
        
        def page_size
          @page_size ||= (@params[:limit] || DEFAULT_PAGE_SIZE).to_i
        end
        
        def page_offset(page_index)
          page_index * page_size
        end
        
        def [](index)
          page_cache[index.to_i] ||= @block.call(params_for_page(index))
        end
        
        def params_for_page(index)
          @params.merge(:offset => page_offset(index.to_i), :limit => page_size)
        end
        
        def get_item_at(position)
          self[position / page_size][position % page_size]
        end
        
        def flatten
          page_cache.flatten(1)
        end
        
        def first
          self[0]
        end
        
      end
      
    end
    
  end
end
