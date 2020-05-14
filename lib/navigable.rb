require 'rack'
require 'rack/bodyparser'
require 'navigable/version'
require 'navigable/application'
require 'navigable/routable'

module Navigable
  def self.application
    @application ||= Rack::Builder.new(app) do
      use Rack::BodyParser, :parsers => {
        'application/json' => proc { |data| JSON.parse data }
      }
    end
  end

  def self.app
    @app ||= Application.new
  end

  def self.resources(&block)
    app.resources(&block)
  end
end
