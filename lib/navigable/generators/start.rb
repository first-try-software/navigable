# frozen-string-literal: true

module Navigable
  module Generators
    class Start < Thor::Group
      include Thor::Actions

      def start_server
        puts 'Ahoy! Navigable is leaving port! (Running Navigable server as a daemon...)'
        run('bundle exec rackup config.ru --daemonize --pid navigable.PID', verbose: false)
        puts
      end
    end
  end
end
