module Navigable
  class Resource
    attr_reader :router, :namespaces, :resource

    def initialize(router, namespaces, resource)
      @router = router
      @namespaces = namespaces
      @resource = resource
    end

    def add
      routes << Index.new(router, namespaces, resource)
      routes << Show.new(router, namespaces, resource)
      routes << Create.new(router, namespaces, resource)
      routes << Update.new(router, namespaces, resource)
      routes << Delete.new(router, namespaces, resource)
    end

    def load
      routes.each(&:load)
    end

    def print
      routes.each(&:print)
    end

    private

    def routes
      @routes ||= []
    end
  end
end
