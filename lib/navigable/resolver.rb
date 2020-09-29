# frozen-string-literal: true

require 'navigable/observer_interface'

module Navigable
  module Resolver
    TYPE = :__resolver__
    RESOLVE_NOT_IMPLEMENTED_MESSAGE = 'Resolver classes must implement a `resolve` method.'

    def self.extended(base)
      base.extend(Manufacturable::Item)
      base.include(ObserverInterface)

      base.instance_eval do
        def default_resolver
          default_manufacturable(TYPE)
        end

        def resolves(key)
          corresponds_to(key, TYPE)
        end
      end

      base.class_eval do
        def resolve
          raise NotImplementedError.new(RESOLVE_NOT_IMPLEMENTED_MESSAGE)
        end
      end
    end
  end
end