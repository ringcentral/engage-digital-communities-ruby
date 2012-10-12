require 'active_model'

module Dimelo
  module API
    class Model

      extend ActiveModel::Translation
      extend ActiveModel::Naming
      include ActiveModel::Validations

      class << self

        def path(*args)
          @path = args.first if args.any?
          @path ||= "/#{name.demodulize.pluralize.underscore}/%{id}"
        end

        def attribute(arg)
          @attributes ||= []
          @attributes << arg
          attr_accessor(arg)
        end

        def attributes(*args)
          args.each do |arg|
            attribute arg
          end
          @attributes
        end

        def submit_attributes(*args)
          @submit_attributes = args if args.any?
          @submit_attributes ||= []
        end

        def has_many(association, options={})
          foreign_class = options[:class_name] || "#{name.gsub(/(\w+)$/, '')}#{association.to_s.singularize.camelize}"
          foreign_reference = self.name.demodulize.underscore
          foreign_key = "#{foreign_reference}_id"

          class_eval <<-EOS, __FILE__, __LINE__ + 1

            def #{association}(client=nil)
              # FIXME: clear cache if client change, or something like that
              client ||= @client
              @#{association} ||= #{foreign_class}.find({:#{foreign_key} => self.id}, client).each do |instance|
                instance.#{foreign_reference} = self
              end
            end

            def #{association}=(items)
              @#{association} = items.each{ |i| i.#{foreign_reference} = self }
            end

          EOS

        end

        def belongs_to(association, options={})
          attr_writer association
          foreign_class = options[:class_name] || "#{name.gsub(/(\w+)$/, '')}#{association.to_s.camelize}"
          foreign_reference = self.name.demodulize.underscore
          foreign_key = "#{association}_id"

          class_eval <<-EOS, __FILE__, __LINE__ + 1

            def #{association}(client=nil)
              client ||= @client
              @#{association} ||= #{foreign_class}.find(self.#{foreign_key}, client)
            end

          EOS
        end

        def find(*args)
          client = args.pop
          criterias = args.pop
          criterias = {:id => criterias} unless criterias.is_a?(Hash)
          Dimelo::API::LazzyCollection.new(criterias) do |criterias|
            parse(client.transport(:get, compute_path(criterias), {:query => criterias}), client)
          end
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
      attr_reader :errors

      delegate :compute_path, :to => 'self.class'

      def initialize(hash={}, client=nil)
        @errors = ActiveModel::Errors.new(self)
        self.client = client
        hash.each do |k,v|
          self.send("#{k}=", v) if self.respond_to?("#{k}=")
        end
      end

      def errors=(errs)
        @errors = ActiveModel::Errors.new(self).tap do |errors|
          errs.each do |error|
            errors.add(error['attribute'], error['type'])
          end
        end
      end

      def attributes
        Hash[self.class.attributes.map{ |key| [key, self.send(key)] }]
      end

      def attributes=(hash)
        hash.each do |attr, value|
          self.send("#{attr}=", value)
        end
      end

      def submit_attributes
        Hash[self.class.submit_attributes.map{ |key| [key, self.send(key)] }]
      end

      def new_record?
        id.blank?
      end

      def save
        if new_record?
          create
        else
          update
        end
      end

      def create
        attrs = submit_attributes
        path = compute_path(attrs)
        response = client.transport(:post, path, :body => attrs)
        self.attributes = Dimelo::API.decode_json(response)
        id.present?
      end

      def update
        attrs = submit_attributes
        path = compute_path(attributes)
        response = client.transport(:put, path, :body => attrs)
        self.attributes = Dimelo::API.decode_json(response)
        errors.empty?
      end

      def valid?
        true
      end

      def destroy
        client.transport(:delete, compute_path(self.attributes))
        freeze
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

      def merge!(other)
        self.attributes = other.attributes
      end

      def to_json
        Dimelo::API.encode_json(self.attributes)
      end

    end
  end
end
