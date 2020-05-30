require 'navigable'

Dir.glob("resources/**/*.rb") do |f|
  require_relative f.gsub('.rb', '')
end

run Navigable.application
