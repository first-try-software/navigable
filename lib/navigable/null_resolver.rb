# frozen-string-literal: true

require 'navigable/resolver'

module Navigable
  class NullResolver
    extend Resolver

    def resolve; end
  end
end
