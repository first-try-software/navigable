# frozen-string-literal: true

module Navigable
  module Generators
    class Stop < Thor::Group
      include Thor::Actions

      def stop_server
        puts 'Ahoy! Navigable is returning to port! (Stopping Navigable server daemon...)'
        run('kill -9 `cat navigable.PID`; rm navigable.PID', verbose: false)
        puts
      end
    end
  end
end
