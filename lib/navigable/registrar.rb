# frozen-string-literal: true

module Navigable
  class Registrar
    VERB_FOR = {
      root: :get,
      index: :get,
      show: :get,
      create: :post,
      update: :put,
      delete: :delete
    }.freeze

    attr_reader :command, :router

    def initialize(command, router)
      @command = command
      @router = router
    end

    def register
      if verb
        print_route
        router.public_send(verb, path, to: command)
      end
    end

    private

    def namespaces
      @namespaces ||= command.name.downcase.split('::')
    end

    def action
      @action ||= namespaces.pop.to_sym
    end

    def verb
      VERB_FOR[action]
    end

    def path
      @path ||= begin
        path = action == :root ? '/' : action_path(namespaces.dup)
        path = "#{path}/:id" if [:show, :update, :delete].include?(action)
        path
      end
    end

    def action_path(segments = namespaces, path = '')
      return path if segments.empty?

      name = segments.shift
      path = "#{path}/#{name}"
      path = "#{path}/:#{name}_id" if segments.length > 0

      action_path(segments, path)
    end

    def print_route
      puts "#{verb.to_s.upcase.rjust(6, ' ')} #{path.ljust(50, ' ')}  =>  #{command}"
    end
  end
end