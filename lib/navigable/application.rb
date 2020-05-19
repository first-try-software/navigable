module Navigable
  class Application
    attr_reader :resources

    def initialize
      @resources = Resources.new(router)
    end

    def call(env)
      router.call(env)
    end

    private

    def router
      @router ||= HttpRouter.new
    end
  end
end
