# frozen-string-literal: true

module Navigable
  module Command
    EXECUTE_NOT_IMPLEMENTED_MESSAGE = 'Class must implement `execute` method.'

    def self.extended(base)
      base.class_eval do
        attr_reader :params

        def initialize(request_params = {})
          @params = request_params
        end

        def execute
          raise NotImplementedError.new(EXECUTE_NOT_IMPLEMENTED_MESSAGE)
        end

        private

        def all_listeners
          (Navigable::Command.default_listeners + self.class.listeners).map { |listener| listener.new }
        end

        def successfully(entity)
          all_listeners.each { |listener| listener.succeeded(entity) }
          render status: 200, json: entity
        end

        def failed_to_validate(entity)
          all_listeners.each { |listener| listener.failed_to_validate(entity) }
          render status: 400, json: { error: "Invalid parameters for entity: #{entity.inspect}" }
        end

        def failed_to_find(entity)
          all_listeners.each { |listener| listener.failed_to_find(entity) }
          render status: 404, json: { error: "Entity not found: #{entity.inspect}" }
        end

        def failed_to_create(entity)
          all_listeners.each { |listener| listener.failed_to_create(entity) }
          render status: 500, json: { error: "There was a problem creating the entity: #{entity.inspect}" }
        end

        def failed_to_update(entity)
          all_listeners.each { |listener| listener.failed_to_update(entity) }
          render status: 500, json: { error: "There was a problem updating the entity: #{entity.inspect}" }
        end

        def failed_to_delete(entity)
          all_listeners.each { |listener| listener.failed_to_delete(entity) }
          render status: 500, json: { error: "There was a problem deleting the entity: #{entity.inspect}" }
        end

        def render(response_params = {})
          Response.new(response_params)
        end
      end
    end

    def self.default_listeners
      @default_listeners ||= []
    end

    def self.add_default_listener(listener)
      default_listeners << listener
    end

    def listeners
      @listeners ||= []
    end

    def add_listener(listener)
      listeners << listener
    end

    def inherited(child)
      Registrar.new(child, Navigable.app.router).register
    end

    def call(env)
      response = self.new(params(env)).public_send(:execute)
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
        [form_params, body_params, url_params].reduce(&:merge)
      end

      def form_params
        @form_params ||= symbolize_keys(Rack::Request.new(env).params || {})
      end

      def body_params
        @body_params ||= symbolize_keys(env['parsed_body'] || {})
      end

      def url_params
        @url_params ||= env['router.params'] || {}
      end

      def symbolize_keys(hash)
        hash.each_with_object({}) { |(key, value), obj| obj[key.to_sym] = value }
      end
    end
  end
end
