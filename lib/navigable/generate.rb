# frozen-string-literal: true

require 'navigable/generators/resource'

module Navigable
  class Generate < Thor
    desc 'resource NAME', 'Generates resource, including actions and a repository'
    def resource(name)
      Generators::Resource.start([name.downcase])
    end
  end
end
