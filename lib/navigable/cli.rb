# frozen-string-literal: true

module Navigable
  class CLI < Thor
    desc 'new APP_NAME', 'Generates a new Navigable application'
    def new(app_name)
      Navigable::Generators::New.start([app_name.downcase])
    end

    desc 'server', 'Starts the Navigable server'
    def server
      Navigable::Generators::Server.start
    end

    map 's' => :server
    map ahoy: :server

    desc 'start', 'Starts the Navigable server daemon'
    def start
      Navigable::Generators::Start.start
    end

    map asea: :start

    desc 'stop', 'Stops the Navigable server daemon'
    def stop
      Navigable::Generators::Stop.start
    end

    map ashore: :stop

    desc 'open', 'Opens the current navigable application in the browser'
    def open
      Navigable::Generators::Open.start
    end
  end
end