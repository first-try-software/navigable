module Navigable
  class Resources
    attr_reader :router

    def initialize(router)
      @router = router
    end

    def add(resource)
      resources << Resource.new(router, namespaces.dup, resource).tap { |resource| resource.add }
    end

    def namespace(namespace, &block)
      namespaces.push(namespace)
      instance_eval(&block)
      namespaces.pop
    end

    def load
      resources.each(&:load)
    end

    private

    def resources
      @resources ||= []
    end

    def namespaces
      @namespaces ||= []
    end
  end
end