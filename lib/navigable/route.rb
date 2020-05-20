module Navigable
  class Route
    attr_reader :router, :namespaces, :resource

    def initialize(router, namespaces, resource)
      @router = router
      @namespaces = namespaces
      @resource = resource
    end

    private

    def path
      @path ||= File.join('/', *namespaces.map { |namespace| "#{namespace}/:#{namespace}_id" }, resource.to_s)
    end

    def routable(namespaces, resource, action)
      namespace_klass(namespaces.dup.push(resource, action))
    end

    def namespace_klass(namespaces, klass = Module)
      return klass if namespaces.empty?

      namespace_klass(namespaces, klass.const_get(:"#{namespaces.shift.capitalize}"))
    end
  end

  class Index < Route
    def load
      router.get("#{path}").to(routable(namespaces, resource, :index))
    end
  end

  class Show < Route
    def load
      router.get("#{path}/:id").to(routable(namespaces, resource, :show))
    end
  end

  class Create < Route
    def load
      router.post("#{path}").to(routable(namespaces, resource, :create))
    end
  end

  class Update < Route
    def load
      router.put("#{path}/:id").to(routable(namespaces, resource, :update))
    end
  end

  class Delete < Route
    def load
      router.delete("#{path}/:id").to(routable(namespaces, resource, :delete))
    end
  end
end