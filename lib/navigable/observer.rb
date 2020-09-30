# frozen-string-literal: true

require 'navigable/observer_interface'

module Navigable
  module Observer
    TYPE = :__observer__

    def self.extended(base)
      base.extend(Manufacturable::Item)
      base.extend(ClassMethods)
      base.include(ObserverInterface)
      base.include(InstanceMethods)
    end

    module ClassMethods
      def observes_all_commands
        corresponds_to_all(TYPE)
      end

      def observes(key)
        corresponds_to(key, TYPE)
      end
    end

    module InstanceMethods
      attr_reader :params

      def inject(params: {})
        @params = params
      end

      def observed_command_key
        manufacturable_item_key
      end
    end
  end
end
