# frozen-string-literal: true

module Navigable
  module Generators
    class New < Thor::Group
      include Thor::Actions

      argument :app_name, type: :string

      def self.source_root
        "#{__dir__}/../../../assets"
      end

      def create_new_app
        puts 'Charting course... (Creating new application...)'
        directory('new_app_template', app_name)
        puts
      end

      def bundle
        puts 'Loading cargo... (Bundling the application...)'
        inside(app_name) do
          run('bundle install')
        end
        puts
      end

      def usage
        run('navigable help', verbose: false)
      end
    end
  end
end
