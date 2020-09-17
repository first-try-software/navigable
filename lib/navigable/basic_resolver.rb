# frozen-string-literal: true

require 'navigable/resolver'

module Navigable
  class BasicResolver
    extend Navigable::Resolver

    def resolve
      @result
    end

    def on_success(result)
      @result = result
    end

    alias_method :on_failure_to_validate, :on_success
    alias_method :on_failure_to_find, :on_success
    alias_method :on_failure_to_create, :on_success
    alias_method :on_failure_to_update, :on_success
    alias_method :on_failure_to_delete, :on_success
    alias_method :on_failure, :on_success
  end
end
