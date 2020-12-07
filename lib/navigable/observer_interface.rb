# frozen-string-literal: true

require 'navigable/observer_map'

module Navigable
  module ObserverInterface
    ObserverMap::METHODS.values.each do |observer_method|
      define_method(observer_method) { |*args| }
    end
  end
end
