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
          source_url: source_url,
          short_url: short_url_string
      }
    end

    def valid?
      @valid = ((url =~ /\A#{URI::regexp(['http', 'https'])}\z/) != nil) if @valid.nil?
      @valid
    end

    def short_url_string
      return nil unless short_url
      "#{full_host_string}#{short_url.access_token}"
    end

    def short_url
      return @short_url if @short_url_looked_up
      @short_url = lookup_short_url
      @short_url_looked_up = true
    end

    def self.access_url_by_token(access_token)
      short_url = ShortUrl.find_by(access_token: access_token)
      if short_url
        short_url.increment_times_accessed
        short_url.source_url
      end
    end

    def top_hundred
      ShortUrl.top_hundred.map do |short_url|
        {
            access_token: short_url.access_token,
            short_url: "#{full_host_string}#{short_url.access_token}",
            source_url: short_url.source_url,
            times_accessed: short_url.times_accessed,
            times_shortened: short_url.times_shortened
        }
      end
    end

    def own_url?
      @own_url = check_if_own_url if @own_url.nil?
      @own_url
    end

    private

    def source_url
      own_url?
    end

    def lookup_short_url
      return nil unless valid?

      shortened = ShortUrl.find_or_create_by(source_url: url)
      shortened.increment_times_shortened

      shortened
    end

    def check_if_own_url
      url =~ /^#{full_host_string}#{AccessTokens::ACCESS_TOKEN_EXPRESSION}$/
    end

    def full_host_string
      @full_host_string ||= build_full_host_string
    end

    def build_full_host_string
      return "#{@scheme}://#{@host}:#{@port}/" if (@port && @port != 80 && @port != 443)
      "#{@scheme}://#{@host}/"
    end
  end
end