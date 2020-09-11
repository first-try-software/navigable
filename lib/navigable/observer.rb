# frozen-string-literal: true

require 'navigable/observer_interface'

module Navigable
  module Observer
    TYPE = :__observer__

    def self.extended(base)
      base.extend(Manufacturable::Item)
      base.include(ObserverInterface)

      base.instance_eval do
        def observes_all_commands
          corresponds_to_all(TYPE)
        end

        def observes(key)
          corresponds_to(key, TYPE)
        end
      end

      base.class_eval do
        attr_reader :params

        def initialize(params: {})
          @params = params
        end

        def observed_command_key
          manufacturable_item_key
        end
      end
    end
  end
end
