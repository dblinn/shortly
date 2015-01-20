require 'rake'
require './models/short_url'

def establish_db_environment
  ENV['RACK_ENV'] ||= 'development'

  Mongoid.load!('./mongoid.yml')
end

namespace :db do

  desc 'Delete a list of short urls by their access tokens. Example: rake db:delete_by_access_tokens["12345678 abcdefgh"] (whitespace between tokens, quote the whole expression)'
  task :delete_by_access_tokens, [:access_token_list] do |task, args|
    establish_db_environment

    access_token_list = args[:access_token_list]
    return unless access_token_list

    delete_short_urls(access_token_list.split)
  end

  private

  def delete_short_urls(access_token_list)
    access_token_list.each do |token|
      short_url = Shortly::ShortUrl.find_by(access_token: token)
      if short_url
        short_url.delete
      else
        puts "Could not find short url with access token '#{token}'"
      end
    end
  end
end