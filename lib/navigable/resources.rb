module Navigable
  class Resources
    attr_reader :router

    def initialize(router)
      @router = router
    end

    def add(resource)
      path_to_resource = path_to(resource)

      router.get("/#{path_to_resource}#{resource}").to(routable(resource, :index))
      router.get("/#{path_to_resource}#{resource}/:id").to(routable(resource, :show))
      router.post("/#{path_to_resource}#{resource}").to(routable(resource, :create))
      router.put("/#{path_to_resource}#{resource}/:id").to(routable(resource, :update))
      router.delete("/#{path_to_resource}#{resource}/:id").to(routable(resource, :delete))
    end

    def namespace(namespace, &block)
      namespaces.push(namespace)
      instance_eval(&block)
      namespaces.pop
    end

    private

    def namespaces
      @namespaces ||= []
    end

    def path_to(resource)
      return '' if namespaces.empty?

      namespaces.map { |namespace| "#{namespace}/:#{namespace}_id" }.join('/') + '/'
    end

    def routable(resource, action)
      klass = namespaces.empty? ? Module : namespace_klass(namespaces.dup)
      klass.const_get(:"#{resource.capitalize}").const_get(:"#{action.capitalize}")
    end

    def namespace_klass(namespaces, klass = Module)
      return klass if namespaces.empty?

      namespace_klass(namespaces, klass.const_get(:"#{namespaces.shift.capitalize}"))
    end
  end
end