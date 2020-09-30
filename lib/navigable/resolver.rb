# frozen-string-literal: true

require 'navigable/observer_interface'

module Navigable
  module Resolver
    TYPE = :__resolver__
    RESOLVE_NOT_IMPLEMENTED_MESSAGE = 'Resolver classes must implement a `resolve` method.'

    def self.extended(base)
      base.extend(Manufacturable::Item)
      base.extend(ClassMethods)
      base.include(ObserverInterface)
      base.include(InstanceMethods)
    end

    module ClassMethods
      def default_resolver
        default_manufacturable(TYPE)
      end

      def resolves(key)
        corresponds_to(key, TYPE)
      end
    end

    module InstanceMethods
      def resolve
        raise NotImplementedError.new(RESOLVE_NOT_IMPLEMENTED_MESSAGE)
      end
    end
  end
end