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
        @resource_name = name.downcase.pluralize
        @resource_klass = @resource_name.capitalize
        @entity_name = name.downcase.singularize
        @entity_klass = @entity_name.capitalize

        puts "Loading cargo... (Creating new resource at #{@resource_klass}...)"

        template('entity.rb.erb', File.join('resources', @resource_name, "#{@entity_name}.rb"))
        template('repository.rb.erb', File.join('resources', @resource_name, 'repository.rb'))
        template('index.rb.erb', File.join('resources', @resource_name, "index.rb"))
        template('show.rb.erb', File.join('resources', @resource_name, "show.rb"))
        template('create.rb.erb', File.join('resources', @resource_name, "create.rb"))
        template('update.rb.erb', File.join('resources', @resource_name, "update.rb"))
        template('delete.rb.erb', File.join('resources', @resource_name, "delete.rb"))

        template('entity_spec.rb.erb', File.join('spec', 'resources', @resource_name, "#{@entity_name}_spec.rb"))
        template('repository_spec.rb.erb', File.join('spec', 'resources', @resource_name, 'repository_spec.rb'))
        template('index_spec.rb.erb', File.join('spec', 'resources', @resource_name, "index_spec.rb"))
        template('show_spec.rb.erb', File.join('spec', 'resources', @resource_name, "show_spec.rb"))
        template('create_spec.rb.erb', File.join('spec', 'resources', @resource_name, "create_spec.rb"))
        template('update_spec.rb.erb', File.join('spec', 'resources', @resource_name, "update_spec.rb"))
        template('delete_spec.rb.erb', File.join('spec', 'resources', @resource_name, "delete_spec.rb"))

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
