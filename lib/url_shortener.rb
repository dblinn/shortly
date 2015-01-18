module Shortly
  class UrlShortener
    attr_reader :url

    def initialize(url:)
      @url = url
    end

    def response
      {
          success: valid?,
          errors: errors,
          original_url: url,
          short_url: short_url
      }
    end

    def valid?
      true
    end

    def errors
      []
    end

    def short_url
      'shorter'
    end
  end
end