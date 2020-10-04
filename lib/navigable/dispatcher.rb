# frozen-string-literal: true

require 'navigable/null_resolver'
require 'navigable/observer'
require 'navigable/command'

module Navigable
  class Dispatcher
    def self.dispatch(key, params: {}, resolver: NullResolver.new)
      self.new(key, params: params, resolver: resolver).dispatch
    end

    def dispatch
      command.execute
      resolver.resolve
    end

    attr_reader :key, :params, :resolver
    private :key, :params, :resolver

    private

    def initialize(key, params:, resolver:)
      @key, @params, @resolver = key, params, resolver
    end

    def observers
      Manufacturable.build_all(Observer::TYPE, key) { |observer| observer.inject(params: params) }
    end

    def command
      build_command.tap { |command| raise Navigable::Command::NotFoundError unless command }
    end

    def build_command
      Manufacturable.build_one(Command::TYPE, key) { |command| command.inject(params: params, observers: observers, resolver: resolver) }
    end
  end
end
