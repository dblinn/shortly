module Shortly
  class AccessTokens
    ACCESS_TOKEN_LENGTH = 8
    ACCESS_TOKEN_EXPRESSION = '[a-z0-9]{8}'
    ACCESS_TOKEN_REGEX = /^#{ACCESS_TOKEN_EXPRESSION}$/

    def self.generate
      # Adapted from http://zh.soup.io/post/36288765/How-to-create-small-unique-tokens-in
      rand(36**ACCESS_TOKEN_LENGTH).to_s(36).center(8, '0')
    end

    def self.valid?(access_token)
      (access_token =~ ACCESS_TOKEN_REGEX) != nil
    end
  end
end
