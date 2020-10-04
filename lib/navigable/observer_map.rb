# frozen-string-literal: true

module Navigable
  class ObserverMap
    METHODS = {
      successfully: :on_success,
      failed_to_validate: :on_failure_to_validate,
      failed_to_find: :on_failure_to_find,
      failed_to_create: :on_failure_to_create,
      failed_to_update: :on_failure_to_update,
      failed_to_delete: :on_failure_to_delete,
      failed: :on_failure
    }.freeze
  end
end
