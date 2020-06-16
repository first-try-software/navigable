# frozen-string-literal: true

module Navigable
  module Action
    EXECUTE_NOT_IMPLEMENTED_MESSAGE = 'Class must implement `execute` method.'

    def self.extended(base)
      base.class_eval do
        attr_reader :params, :headers, :listeners

        def initialize(request_params: {}, request_headers: {}, listeners: build_listeners)
          @params = request_params
          @headers = request_headers
          @listeners = listeners
        end

        def execute
          raise NotImplementedError.new(EXECUTE_NOT_IMPLEMENTED_MESSAGE)
        end

        private

        def build_listeners
          Manufacturable.build(Navigable::Listener::TYPE, self.class) || []
        end

        def successfully(entity)
          listeners.each { |listener| listener.on_success(entity) }
          render status: 200, json: entity
        end

        def failed_to_validate(entity)
          listeners.each { |listener| listener.on_failure_to_validate(entity) }
          render status: 400, json: { error: "Invalid parameters for entity: #{entity}" }
        end

        def failed_to_find(entity)
          listeners.each { |listener| listener.on_failure_to_find(entity) }
          render status: 404, json: { error: "Entity not found: #{entity}" }
        end

        def failed_to_create(entity)
          listeners.each { |listener| listener.on_failure_to_create(entity) }
          render status: 500, json: { error: "There was a problem creating the entity: #{entity}" }
        end

        def failed_to_update(entity)
          listeners.each { |listener| listener.on_failure_to_update(entity) }
          render status: 500, json: { error: "There was a problem updating the entity: #{entity}" }
        end

        def failed_to_delete(entity)
          listeners.each { |listener| listener.on_failure_to_delete(entity) }
          render status: 500, json: { error: "There was a problem deleting the entity: #{entity}" }
        end

        def render(response_params = {})
          Response.new(response_params)
        end
      end
    end

    def register_action
      Registrar.new(self, Navigable.app.router).register
    end

    def call(env)
      response = self.new(request_params: params(env), request_headers: headers(env)).public_send(:execute)
      raise InvalidResponse unless response.is_a?(Navigable::Response)
      response.to_rack_response
    end

    def params(env)
      Params.new(env).to_h
    end

    def headers(env)
      Headers.new(env).to_h
    end
  end
end
