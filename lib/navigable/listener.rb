# frozen-string-literal: true

require_relative './command'

module Navigable
  class Listener
    def self.add_default_listener
      Navigable::Command.add_default_listener(self)
    end

    def self.add_listener(command_klass)
      command_klass.add_listener(self)
    end

    def succeeded(entity); end
    def failed_to_validate(entity); end
    def failed_to_find(entity); end
    def failed_to_create(entity); end
    def failed_to_update(entity); end
    def failed_to_delete(entity); end
  end
end
