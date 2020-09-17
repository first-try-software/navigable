# frozen-string-literal: true

module Navigable
  module ObserverInterface
    def on_success(*args, **kwargs); end
    def on_failure_to_validate(*args, **kwargs); end
    def on_failure_to_find(*args, **kwargs); end
    def on_failure_to_create(*args, **kwargs); end
    def on_failure_to_update(*args, **kwargs); end
    def on_failure_to_delete(*args, **kwargs); end
    def on_failure(*args, **kwargs); end
  end
end
