module Navigable
  class Resource
    attr_reader :router, :namespaces, :resource

    def initialize(router, namespaces, resource)
      @router = router
      @namespaces = namespaces
      @resource = resource
    end

    def add
      path_to_resource = path_to(resource)

      router.get("/#{path_to_resource}#{resource}").to(routable(namespaces.dup, resource, :index))
      router.get("/#{path_to_resource}#{resource}/:id").to(routable(namespaces.dup, resource, :show))
      router.post("/#{path_to_resource}#{resource}").to(routable(namespaces.dup, resource, :create))
      router.put("/#{path_to_resource}#{resource}/:id").to(routable(namespaces.dup, resource, :update))
      router.delete("/#{path_to_resource}#{resource}/:id").to(routable(namespaces.dup, resource, :delete))
    end

    private

    def path_to(resource)
      return '' if namespaces.empty?

      namespaces.map { |namespace| "#{namespace}/:#{namespace}_id" }.join('/') + '/'
    end

    def routable(namespaces, resource, action)
      klass = namespaces.empty? ? Module : namespace_klass(namespaces)
      klass.const_get(:"#{resource.capitalize}").const_get(:"#{action.capitalize}")
    end

    def namespace_klass(namespaces, klass = Module)
      return klass if namespaces.empty?

      namespace_klass(namespaces, klass.const_get(:"#{namespaces.shift.capitalize}"))
    end
  end
end