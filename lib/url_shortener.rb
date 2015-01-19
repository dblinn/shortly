require 'uri'

module Shortly
  class UrlShortener
    attr_reader :url

    def initialize(url:, request_host:, request_scheme:)
      @url = url
      @host = request_host
      @scheme = request_scheme
    end

    def response
      {
          success: valid?,
          original_url: url,
          short_url: short_url
      }
    end

    def valid?
      (url =~ /\A#{URI::regexp(['http', 'https'])}\z/) != nil
    end

    def short_url
      "#{@scheme}://#{@host}/shorter"
    end
  end
end