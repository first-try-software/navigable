# frozen-string-literal: true

module Navigable
  module Generators
    class Server < Thor::Group
      include Thor::Actions

      def start
        puts 'Ahoy! Navigable is leaving port! (Running navigable server...)'
        run('bundle exec rackup config.ru', verbose: false)
      rescue Interrupt
      end
    end
  end
end
