# frozen-string-literal: true

module Navigable
  class Application
    def initialize
      router.get('/', to: Navigable::Splash)
    end

    def call(env)
      router.call(env)
    end

    def router
      @router ||= Hanami::Router.new
    end
  end
end
