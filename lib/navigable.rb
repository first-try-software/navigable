# frozen-string-literal: true

require 'rack'
require 'rack/bodyparser'
require 'hanami/router'
require 'json'
require 'thor'
require 'base64'
require 'inflector'
require 'core_extension'

require 'navigable/version'
require 'navigable/generators/new'
require 'navigable/generators/open'
require 'navigable/generators/server'
require 'navigable/generators/start'
require 'navigable/generators/stop'
require 'navigable/generators/resource'
require 'navigable/generate'
require 'navigable/cli'
require 'navigable/registrar'
require 'navigable/splash'
require 'navigable/application'
require 'navigable/response'
require 'navigable/entity'
require 'navigable/listener'
require 'navigable/command/params'
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
