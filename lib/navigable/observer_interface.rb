# frozen-string-literal: true

module Navigable
  module ObserverInterface
    def on_success(*args); end
    def on_failure_to_validate(*args); end
    def on_failure_to_find(*args); end
    def on_failure_to_create(*args); end
    def on_failure_to_update(*args); end
    def on_failure_to_delete(*args); end
    def on_failure(*args); end
  end
end
