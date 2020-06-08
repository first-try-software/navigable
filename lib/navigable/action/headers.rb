# frozen-string-literal: true

module Navigable
  module Action
    class Headers
      attr_reader :env

      def initialize(env)
        @env = env
      end

      def to_h
        {
          accept_media_types: accept_media_types,
          preferred_media_type: preferred_media_type
        }
      end

      private

      def accept_media_types
        @accept_media_types ||= Rack::Request.new(env).accept_media_types
      end

      def preferred_media_type
        accept_media_types.first
      end
    end
  end
end
