source 'https://rubygems.org'
ruby '2.2.0'

gem 'sinatra'
gem 'sinatra-contrib', github: 'maccman/sinatra-contrib'
gem 'rake'

# Assets
gem 'sprockets'
gem 'sprockets-memcache-store'
gem 'uglifier'
gem 'haml'

# DB
gem 'mongoid'

group :development, :test do
	gem 'rspec'
	gem 'pry'
end

group :test do
	gem 'rspec-html-matchers', github: 'kucaahbe/rspec-html-matchers'
end

# Server
gem 'thin'