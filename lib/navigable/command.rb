# frozen-string-literal: true

module Navigable
  module Command
    EXECUTE_NOT_IMPLEMENTED_MESSAGE = 'Class must implement `execute` method or configure an alternative with `responds_with_method`.'

    def self.extended(base)
      base.class_eval do
        def render(**params)
          Response.new(params)
        end

        def execute
          raise NotImplementedError.new(EXECUTE_NOT_IMPLEMENTED_MESSAGE)
        end
      end
    end

    def inherited(child)
      child.responds_with_method(@responds_with_method) if @responds_with_method
      Registrar.new(child, Navigable.app.router).register
    end

    def responds_with_method(method_name)
      @responds_with_method = method_name
    end

    def call(env)
      response = self.new(params(env)).public_send(@responds_with_method || :execute)
      raise InvalidResponse unless response.is_a?(Navigable::Response)
      response.to_rack_response
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
        @request_params ||= symbolize_keys(Rack::Request.new(env).params || {})
      end

      def body_params
        @body_params ||= symbolize_keys(env['parsed_body'] || {})
      end

      def router_params
        @router_params ||= env['router.params'] || {}
      end

      def symbolize_keys(hash)
        hash.each_with_object({}) { |(key, value), obj| obj[key.to_sym] = value }
      end
    end
  end
end
