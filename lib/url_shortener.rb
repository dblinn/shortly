module Shortly
  class UrlShortener
    attr_reader :url

    def initialize(url:)
      @url = url
    end

    def response
      {
          success: is_valid?,
          original_url: url,
          short_url: short_url
      }
    end

    def is_valid?
      false
    end

    def short_url
      'shorter'
    end
  end
end