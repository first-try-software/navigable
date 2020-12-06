# frozen-string-literal: true

require 'navigable/resolver'

module Navigable
  class NullResolver
    extend Navigable::Resolver

    def resolve
      @result
    end

    ObserverMap::METHODS.values.each do |observer_method|
      define_method(observer_method) do |result|
        @result = result
      end
    end
  end
end
