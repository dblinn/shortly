require 'uri'
require './models/short_url'

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
      shortened = ShortUrl.find_or_create_by(original_url: url)

      "#{@scheme}://#{@host}/#{shortened.access_token}"
    end
  end
end