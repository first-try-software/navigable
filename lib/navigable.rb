require 'rack'
require 'rack/bodyparser'
require 'http_router'
require 'json'
require 'navigable/version'
require 'navigable/route'
require 'navigable/resource'
require 'navigable/resources'
require 'navigable/application'
require 'navigable/response'
require 'navigable/command'

module Navigable
  def self.application
    @application ||= Rack::Builder.new(app) do
      use Rack::BodyParser, :parsers => {
        'application/json' => proc { |data| JSON.parse(data) }
      }
    end
  end

  def self.app
    @app ||= Application.new
  end

  def self.resources(&block)
    app.resources.instance_eval(&block)
  end

  def self.load_resources
    app.resources.load
  end

  def self.print_resources
    app.resources.print
  end
end
