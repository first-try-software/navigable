module Navigable
  module Routable
    def inherited(child)
      child.responds_with_method(@responds_with_method) if @responds_with_method
    end

    def responds_with_method(method_name)
      @responds_with_method = method_name
    end

    def call(env)
      self.new(**params(env)).public_send(@responds_with_method || :execute)
    end

    def params(env)
      Params.new(env).to_h
    end

    class Params
      attr_reader :env

      def initialize(env)
        @env = env
      end

      def to_h
        [request_params, body_params, router_params].reduce(&:merge)
      end

      def request_params
        @request_params ||= symbolize_keys(env['router.request']&.rack_request&.params || {})
      end

      def body_params
        @body_params ||= symbolize_keys(env['parsed_body'] || {})
      end

      def router_params
        @router_params ||= env['router.params'] || {}
      end

      def symbolize_keys(hash)
        hash&.map { |key, value| [key.to_sym, value] }&.to_h || {}
      end
    end
  end
end
