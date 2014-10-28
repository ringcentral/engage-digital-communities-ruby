module Dimelo::CCP
  module API

    class BasicObject
      # http://ruby-doc.org/core-1.9/classes/BasicObject.html
      # http://sequel.heroku.com/2010/03/31/sequelbasicobject-and-ruby-18/
      KEEP_METHODS = %w(__id__ __send__ instance_eval == equal? initialize method_missing respond_to?)

      def self.remove_methods!
        m = (private_instance_methods + instance_methods) - KEEP_METHODS
        m.each{|m| undef_method(m)}
      end
      remove_methods!
    end if not defined?(BasicObject)

  end
end
