# frozen-string-literal: true

require_relative './action'

module Navigable
  class Listener
    def self.listen_to_all_actions
      Navigable::Action.add_default_listener(self)
    end

    def self.listen_to(action_klass)
      action_klass.add_listener(self)
    end

    def on_success(entity); end
    def on_failure_to_validate(entity); end
    def on_failure_to_find(entity); end
    def on_failure_to_create(entity); end
    def on_failure_to_update(entity); end
    def on_failure_to_delete(entity); end
  end
end
