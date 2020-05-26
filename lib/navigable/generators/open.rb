# frozen-string-literal: true

module Navigable
  module Generators
    class Open < Thor::Group
      include Thor::Actions

      def open_browser
        puts 'All aboard! (Starting Navigable application in browser...)'
        run("open 'http://localhost:9292'", verbose: false)
        puts
      end
    end
  end
end
