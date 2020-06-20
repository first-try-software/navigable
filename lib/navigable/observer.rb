# frozen-string-literal: true

require 'navigable/observer_interface'

module Navigable
  module Observer
    TYPE = :__observer__

    def self.extended(base)
      base.extend(Manufacturable::Item)
      base.include(ObserverInterface)
    end

    def observes_all_commands
      corresponds_to_all(TYPE)
    end

    def observes(key)
      corresponds_to(key, TYPE)
    end
  end
end
