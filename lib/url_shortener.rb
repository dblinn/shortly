require 'uri'

module Shortly
  class UrlShortener
    attr_reader :url

    def initialize(url:)
      @url = url
    end

    def response
      {
          success: valid?,
          original_url: url,
          short_url: short_url
      }
    end

    def valid?
      begin
        url =~ /\A#{URI::regexp(['http', 'https'])}\z/
      rescue URI::InvalidURIError
        false
      end
    end

    def short_url
      # Source: http://zh.soup.io/post/36288765/How-to-create-small-unique-tokens-in
      # rand(36**8).to_s(36)
      # class Customer < ActiveRecord::Base
      #   validates_presence_of :access_token
      #   validates_uniqueness_of :access_token
      #
      #   protected
      #   def before_validation_on_create
      #     self.access_token = rand(36**8).to_s(36) if self.new_record? and self.access_token.nil?
      #   end
      # end

    'shorter'
    end
  end
end