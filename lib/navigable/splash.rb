# frozen-string-literal: true

module Navigable
  class Splash
    ASSET_PATH = "#{__dir__}/../../assets/splash/"

    FILES = {
      html: "splash.html.erb",
      font: "font.woff",
      image: "splash.png"
    }

    def self.call(env)
      html = ERB.new(File.read("#{ASSET_PATH}#{FILES[:html]}")).result(binding)
      [200, {'Content-Type'=>'text/html'}, [html]]
    end

    def self.font
      base64_encode(FILES[:font])
    end

    def self.image
      base64_encode(FILES[:image])
    end

    def self.base64_encode(file)
      Base64.strict_encode64(File.read("#{ASSET_PATH}#{file}"))
    end
  end
end