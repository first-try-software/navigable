require 'http_router'

module Navigable
  class Application
    def initialize
      @namespaces = []
    end

    def call(env)
      http_router.call(env)
    end

    def resources(&block)
      instance_eval(&block)
    end

    private

    def add(resource)
      namespaces = namespaces(resource)

      http_router.get("/#{namespaces}#{resource}").to(routable(resource, :index))
      http_router.get("/#{namespaces}#{resource}/:id").to(routable(resource, :show))
      http_router.post("/#{namespaces}#{resource}").to(routable(resource, :create))
      http_router.put("/#{namespaces}#{resource}/:id").to(routable(resource, :update))
      http_router.delete("/#{namespaces}#{resource}/:id").to(routable(resource, :delete))
    end

    def namespaces(resource)
      return '' if @namespaces.empty?

      @namespaces.map { |namespace| "#{namespace}/:#{namespace}_id" }.join('/') + '/'
    end

    def namespace(namespace, &block)
      @namespaces.push(namespace)
      instance_eval(&block)
      @namespaces.pop
    end

    def http_router
      @http_router ||= ::HttpRouter.new
    end

    def routable(resource, action)
      klass = @namespaces.empty? ? Module : namespace_klass(@namespaces.dup)
      klass.const_get(:"#{resource.capitalize}").const_get(:"#{action.capitalize}")
    end

    def namespace_klass(namespaces, klass = Module)
      return klass if namespaces.empty?

      namespace_klass(namespaces, klass.const_get(:"#{namespaces.shift.capitalize}"))
    end
  end
end
