module Navigable
  class Application
    def call(env)
      router.call(env)
    end

    def router
      @router ||= HttpRouter.new
    end
  end
end
