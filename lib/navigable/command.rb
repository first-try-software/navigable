# frozen-string-literal: true

require 'navigable/observable'

module Navigable
  module Command
    class NotFoundError < StandardError; end

    TYPE = :__command__
    EXECUTE_NOT_IMPLEMENTED_MESSAGE = 'Class must implement `execute` method.'

    def self.extended(base)
      base.extend(Manufacturable::Item)
      base.include(Observable)

      base.instance_eval do
        def corresponds_to(key)
          super(key, TYPE)
        end
      end

      base.class_eval do
        attr_reader :params, :observers

        def inject(params: {}, observers: [])
          @params = params
          @observers = observers
        end

        def execute
          raise NotImplementedError.new(EXECUTE_NOT_IMPLEMENTED_MESSAGE)
        end
      end
    end
  end
end

