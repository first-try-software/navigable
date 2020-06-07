# frozen-string-literal: true

module Navigable
  module Command
    class Params
      attr_reader :env

      def initialize(env)
        @env = env
      end

      def to_h
        [form_params, body_params, url_params].reduce(&:merge)
      end

      def form_params
        @form_params ||= symbolize_keys(Rack::Request.new(env).params || {})
      end

      def body_params
        @body_params ||= symbolize_keys(env['parsed_body'] || {})
      end

      def url_params
        @url_params ||= env['router.params'] || {}
      end

      def symbolize_keys(hash)
        hash.each_with_object({}) { |(key, value), obj| obj[key.to_sym] = value }
      end
    end
  end
end
