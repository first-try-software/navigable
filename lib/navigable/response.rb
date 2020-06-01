# frozen-string-literal: true

module Navigable
  class InvalidResponse < StandardError; end

  class Response
    attr_reader :params, :status

    def initialize(params)
      @params = params
      @status = params[:status] || 200
    end

    def to_rack_response
      [status, headers, content]
    end

    private

    def headers
      headers = params[:headers] || {}
      headers['Content-Type'] = content_type if content_type
      headers
    end

    def content_type
      return 'application/json' if json
      return 'text/html' if html
      return 'text/plain' if text
    end

    def content
      [json || html || text || body || ""]
    end

    def json
      return unless params[:json]
      return params[:json].to_s if valid_json?(params[:json])

      params[:json].to_json
    end

    def html
      params[:html]
    end

    def text
      params[:text]
    end

    def body
      params[:body]
    end

    def valid_json?(json)
      JSON.parse(json.to_s)
      return true
    rescue JSON::ParserError => e
      return false
    end
  end
end
