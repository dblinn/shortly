require 'sinatra'
require 'haml'
require 'mongoid'
require 'sinatra/json'
require './lib/url_shortener'

require 'sinatra/reloader' if development?
require 'pry' if development?

module Shortly
  class Application < Sinatra::Application
    set :public_folder, File.dirname(__FILE__) + '/assets'
    Mongoid.load!('./mongoid.yml')

    get '/' do
      haml :index
    end

    get '/top_hundred' do
      'This is a placeholder for the top 100'
    end

    post '/shorten' do
      json UrlShortener.new(url: params[:url], request_host: request.host, request_scheme: request.scheme).response
    end
  end
end
