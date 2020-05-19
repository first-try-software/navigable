module Navigable
  class Resources
    attr_reader :router

    def initialize(router)
      @router = router
    end

    def add(resource)
      Resource.new(router, namespaces.dup, resource).add
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
  end
end