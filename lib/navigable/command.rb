# frozen-string-literal: true

require 'navigable/observable'

module Navigable
  module Command
    class NotFoundError < StandardError; end

    TYPE = :__command__
    EXECUTE_NOT_IMPLEMENTED_MESSAGE = 'Class must implement `execute` method.'

    def self.extended(base)
      base.extend(Manufacturable::Item)
      base.extend(ClassMethods)
      base.include(Observable)
      base.include(InstanceMethods)
    end

    module ClassMethods
      def corresponds_to(key)
        super(key, TYPE)
      end
    end

    module InstanceMethods
      attr_reader :params, :observers, :resolver

      def inject(params: {}, observers: [], resolver: NullResolver.new)
        @params = params
        @observers = observers
        @resolver = resolver
      end

      def execute
        raise NotImplementedError.new(EXECUTE_NOT_IMPLEMENTED_MESSAGE)
      end
    end
  end
end

