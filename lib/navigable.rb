require 'rack'
require 'rack/bodyparser'
require 'http_router'
require 'json'
require 'navigable/version'
require 'navigable/registrar'
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
end
