# frozen-string-literal: true

module Navigable
  module Generators
    class Resource < Thor::Group
      include Thor::Actions

      argument :name, type: :string

      def self.source_root
        "#{__dir__}/../../../assets/templates"
      end

      def self.destination_root
        Dir.pwd
      end

      def create
        puts "Loading cargo... (Creating new resource at #{name}...)"

        @resource_name = name
        @resource_klass = name.capitalize

        ['index', 'show', 'create', 'update', 'delete'].each do |action|
          @action_name = action
          @action_klass = action.capitalize

          template('command.rb.erb', File.join('resources', name, "/#{action}.rb"))
          template('command_spec.rb.erb', File.join('spec', 'resources', name, "/#{action}_spec.rb"))
        end

        template('repository.rb.erb', File.join('resources', name, '/repository.rb'))
        template('repository_spec.rb.erb', File.join('spec', 'resources', name, '/repository_spec.rb'))

        puts
      end

      def run_specs
        puts 'Checking manifest... (Running specs...)'
        run('bundle exec rspec')
        puts
      end
    end
  end
end
