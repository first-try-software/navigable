module Navigable
  class Application
    def call(env)
      router.call(env)
    end

    def resources
      @resources ||= Resources.new(router)
    end

    private

    def router
      @router ||= HttpRouter.new
    end
  end
end
