# frozen-string-literal: true

require 'navigable/null_resolver'
require 'navigable/observer'
require 'navigable/command'

module Navigable
  class Dispatcher
    def self.dispatch(key, params:, resolver: NullResolver.new)
      self.new(key, params: params, resolver: resolver).dispatch
    end

    def dispatch
      command.execute
      @resolver.resolve
    end

    private

    def initialize(key, params:, resolver:)
      @key, @params, @resolver = key, params, resolver
    end

    def observers
      Manufacturable.build_all(Observer::TYPE, @key).push(@resolver)
    end

    def command
      Manufacturable.build_one(Command::TYPE, @key, params: @params, observers: observers)
    end
  end
end
