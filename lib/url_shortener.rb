require 'uri'
require_relative './../models/short_url'

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
          source_url: source_url_string,
          short_url: short_url_string
      }
    end

    def valid?
      @valid = calculate_validity if @valid.nil?
      @valid
    end

    def short_url_string
      return nil unless short_url
      "#{full_host_string}#{short_url.access_token}"
    end

    def source_url_string
      own_url? ? source_url_from_short_url : url
    end

    def short_url
      # Memoize like this because @short_url may legitimately have been looked up to be nil
      return @short_url if @short_url_looked_up
      @short_url_looked_up = true
      @short_url = lookup_short_url
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

    def http_port?
      @port == 80
    end

    def https_port?
      @port == 443
    end

    private

    def calculate_validity
      return false unless ((url =~ /\A#{URI::regexp(['http', 'https'])}\z/) != nil)
      own_url? ? (short_url != nil) : true
    end

    def lookup_short_url
      if own_url?
        shortened = lookup_short_url_for_own_url
      else
        return nil unless valid?
        shortened = ShortUrl.find_or_create_by(source_url: url)
        shortened.increment_times_shortened
      end

      shortened
    end

    def lookup_short_url_for_own_url
      access_token = /(#{AccessTokens::ACCESS_TOKEN_EXPRESSION})$/.match(url).captures[0]
      shortened = ShortUrl.find_by(access_token: access_token)
      shortened.try(:increment_times_shortened)
      shortened
    end

    def check_if_own_url
      (url =~ /^#{host_comparison_regex}#{AccessTokens::ACCESS_TOKEN_EXPRESSION}$/) != nil
    end

    def full_host_string
      @full_host_string ||= (build_full_host_string + '/')
    end

    def source_url_from_short_url
      return short_url.source_url if short_url
      url
    end

    def build_full_host_string
      return "#{@scheme}://#{@host}:#{@port}" if (@port && !http_port? && !https_port?)
      "#{@scheme}://#{@host}"
    end

    def host_comparison_regex
      "#{build_full_host_string}#{optional_port_regex}/"
    end

    def optional_port_regex
      return '(?::80)?' if http_port?
      return '(?::443)?' if https_port?
      ''
    end
  end
end