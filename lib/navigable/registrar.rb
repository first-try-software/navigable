# frozen-string-literal: true

module Navigable
  class InvalidRoute < StandardError; end

  class Registrar
    VERB_FOR = {
      root: :get,
      index: :get,
      show: :get,
      create: :post,
      update: :put,
      delete: :delete
    }.freeze

    attr_reader :action_klass, :router

    def initialize(action_klass, router)
      @action_klass = action_klass
      @router = router
    end

    def register
      raise InvalidRoute unless valid_route?

      router.public_send(verb, path, to: action_klass)
    end

    private

    def valid_route?
      return false if verb.nil?
      return false if action_name == :root && !namespaces.empty?

      true
    end

    def namespaces
      @namespaces ||= action_klass.name.downcase.split('::')
    end

    def action_name
      @action_name ||= namespaces.pop.to_sym
    end

    def verb
      VERB_FOR[action_name]
    end

    def path
      @path ||= begin
        path = action_name == :root ? '/' : action_name_path(namespaces.dup)
        path = "#{path}/:id" if [:show, :update, :delete].include?(action_name)
        path
      end
    end

    def action_name_path(segments = namespaces, path = '')
      return path if segments.empty?

      name = segments.shift
      path = "#{path}/#{name}"
      path = "#{path}/:#{name}_id" if segments.length > 0

      action_name_path(segments, path)
    end
  end
end