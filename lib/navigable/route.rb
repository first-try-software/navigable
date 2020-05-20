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

    def destination(namespaces = destination_names, klass = Module)
      return klass if namespaces.empty?

      destination(namespaces, klass.const_get(:"#{namespaces.shift.capitalize}"))
    end

    def destination_name
      destination_names.map(&:capitalize).join('::')
    end

    def destination_names
      namespaces.dup.push(resource, action)
    end

    def action
      self.class.name.split('::').last
    end
  end

  class Index < Route
    def load
      router.get("#{path}").to(destination)
    end

    def print
      puts "     GET #{path}  =>  #{destination_name}"
    end
  end

  class Show < Route
    def load
      router.get("#{path}/:id").to(destination)
    end

    def print
      puts "     GET #{path}/:id  =>  #{destination_name}"
    end
  end

  class Create < Route
    def load
      router.post("#{path}").to(destination)
    end

    def print
      puts "    POST #{path}  =>  #{destination_name}"
    end
  end

  class Update < Route
    def load
      router.put("#{path}/:id").to(destination)
    end

    def print
      puts "     PUT #{path}/:id  =>  #{destination_name}"
    end
  end

  class Delete < Route
    def load
      router.delete("#{path}/:id").to(destination)
    end

    def print
      puts "  DELETE #{path}/:id  =>  #{destination_name}"
    end
  end
end