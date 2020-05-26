require 'navigable'

Dir.glob("commands/**/*.rb") do |f|
  require_relative f.gsub('.rb', '')
end

run Navigable.application
