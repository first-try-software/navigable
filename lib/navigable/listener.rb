# frozen-string-literal: true

require_relative './action'

module Navigable
  module Listener
    TYPE = :__observer__

    def self.extended(base)
      base.include(ListenerInterface)
      base.extend(Manufacturable::Item)
    end

    def listens_to_all_actions
      corresponds_to_all
    end

    def listens_to(action_klass)
      corresponds_to(action_klass, TYPE)
    end
  end

  module ListenerInterface
    def on_success(*args); end
    def on_failure_to_validate(*args); end
    def on_failure_to_find(*args); end
    def on_failure_to_create(*args); end
    def on_failure_to_update(*args); end
    def on_failure_to_delete(*args); end
  end
end
