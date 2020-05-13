require "navigable/version"
require "navigable/application"

module Navigable
  def self.application
    @application ||= Application.new
  end
end
