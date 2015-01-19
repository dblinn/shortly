require 'uri'
require './models/short_url'

module Shortly
  class UrlShortener
    attr_reader :url

    def initialize(url:, request_host:, request_scheme:, port: nil)
      @url = url
      @host = request_host
      @scheme = request_scheme
      @port = port
    end

    def response
      {
          success: valid?,
          source_url: url,
          short_url: short_url
      }
    end

    def valid?
      (url =~ /\A#{URI::regexp(['http', 'https'])}\z/) != nil
    end

    def short_url
      shortened = ShortUrl.find_or_create_by(source_url: url)

      "#{full_host_string}#{shortened.access_token}"
    end

    def self.access_url_by_token(access_token)
      short_url = ShortUrl.find_by(access_token: access_token)
      if short_url
        short_url.increment_times_accessed
        short_url.source_url
      end
    end

    private

    def full_host_string
      return "#{@scheme}://#{@host}:#{@port}/" if (@port && @port != 80 && @port != 443)
      "#{@scheme}://#{@host}/"
    end
  end
end