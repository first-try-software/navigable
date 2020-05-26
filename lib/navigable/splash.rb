# frozen-string-literal: true

module Navigable
  class Splash
    def self.call(env)
      [200, {'Content-Type'=>'text/html'}, [ERB.new(File.read("#{__dir__}/../../assets/splash.html.erb")).result]]
    end
  end
end