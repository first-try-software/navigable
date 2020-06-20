# frozen-string-literal: true

module Navigable
  module Observable
    OBSERVERS_NOT_IMPLEMENTED_MESSAGE = 'Class must implement `observers` method.'

    def observers
      raise NotImplementedError.new(OBSERVERS_NOT_IMPLEMENTED_MESSAGE)
    end

    def successfully(*args)
      observers.each { |observer| observer.on_success(*args) }
    end

    def failed_to_validate(*args)
      observers.each { |observer| observer.on_failure_to_validate(*args) }
    end

    def failed_to_find(*args)
      observers.each { |observer| observer.on_failure_to_find(*args) }
    end

    def failed_to_create(*args)
      observers.each { |observer| observer.on_failure_to_create(*args) }
    end

    def failed_to_update(*args)
      observers.each { |observer| observer.on_failure_to_update(*args) }
    end

    def failed_to_delete(*args)
      observers.each { |observer| observer.on_failure_to_delete(*args) }
    end

    def failed(*args)
      observers.each { |observer| observer.on_failure(*args) }
    end
  end
end