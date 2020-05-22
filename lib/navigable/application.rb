# frozen-string-literal: true

module Navigable
  class Application
    def call(env)
      router.call(env)
    end

    def router
      @router ||= Hanami::Router.new
    end
  end
end
