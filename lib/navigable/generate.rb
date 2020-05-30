# frozen-string-literal: true

module Navigable
  class Generate < Thor
    desc 'resource NAME', 'Generates resource, including commands and a repository'
    def resource(name)
      Navigable::Generators::Resource.start([name.downcase])
    end
  end
end
