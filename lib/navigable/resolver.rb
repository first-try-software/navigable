# frozen-string-literal: true

require 'navigable/observer_interface'

module Navigable
  module Resolver
    RESOLVE_NOT_IMPLEMENTED_MESSAGE = 'Class must implement `resolve` method.'

    def self.extended(base)
      base.include(ObserverInterface)
      base.class_eval do
        def resolve
          raise NotImplementedError.new(RESOLVE_NOT_IMPLEMENTED_MESSAGE)
        end
      end
    end
  end
end