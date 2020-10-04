# frozen-string-literal: true

require 'navigable/observer_map'
require 'navigable/executor'

module Navigable
  module Observable
    OBSERVERS_NOT_IMPLEMENTED_MESSAGE = 'Class must implement `observers` method.'
    RESOLVER_NOT_IMPLEMENTED_MESSAGE = 'Class must implement `resolver` method.'

    def observers
      raise NotImplementedError.new(OBSERVERS_NOT_IMPLEMENTED_MESSAGE)
    end

    def resolver
      raise NotImplementedError.new(RESOLVER_NOT_IMPLEMENTED_MESSAGE)
    end

    ObserverMap::METHODS.each_pair do |observable_method, observer_method|
      define_method(observable_method) do |*args, **kwargs|
        observers.each do |observer|
          Navigable::Executor.execute { observer.send(observer_method, *args, **kwargs) }
        end

        resolver.send(observer_method, *args, **kwargs)
      end
    end
  end
end