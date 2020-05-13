module Navigable
  module Routable
    def inherited(child)
      child.responds_with_method(@responds_with_method) if @responds_with_method
    end

    def responds_with_method(method_name)
      @responds_with_method = method_name
    end

    def call(env)
      params = env['router.params'].merge(symbolize_keys(env['parsed_body']))

      self.new(**params).public_send(@responds_with_method || :execute)
    end

    def symbolize_keys(hash)
      hash&.map { |key, value| [key.to_sym, value] }&.to_h || {}
    end
  end
end
