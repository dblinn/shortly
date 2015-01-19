require 'mongoid'
require './lib/access_tokens'

module Shortly
  class ShortUrl
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    field :original_url
    field :access_token
    field :times_accessed, type: Integer, default: 0
    field :times_shortened, type: Integer, default: 1
    field :last_accessed_time, type: Time, default: Time.current
    field :last_shortened_time, type: Time, default: Time.current

    validates_presence_of :original_url
    # Don't validate_presence_of access_token on new record because the validation will happen before the before_create generate it
    validates_presence_of :access_token, unless: :new_record?
    before_create :ensure_unique_access_token

    attr_readonly :original_url
    attr_readonly :access_token

    scope :with_access_token, ->(access_token){ where(access_token: access_token) }

    def increment_times_accessed
      self.times_accessed += 1
      self.last_accessed_time = Time.current
      update_attributes!(times_accessed: self.times_accessed, last_accessed_time: self.last_accessed_time)
    end

    def increment_times_shortened
      self.times_shortened += 1
      self.last_shortened_time = Time.current
      update_attributes!(times_shortened: self.times_shortened, last_shortened_time: self.last_shortened_time)
    end

    private

    def generate_access_token
      AccessTokens.generate
    end

    def ensure_unique_access_token
      self.access_token = AccessTokens.generate unless AccessTokens.valid?(self.access_token)
      while ShortUrl.with_access_token(self.access_token).size > 0
        new_token = AccessTokens.generate
        self.access_token = new_token
      end
    end
  end
end
