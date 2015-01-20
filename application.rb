require 'sinatra'
require 'haml'
require 'mongoid'
require 'sinatra/json'
require_relative './lib/url_shortener'
require_relative './mongoid_config'

require 'sinatra/reloader' if development?
require 'pry' if development?

module Shortly
  class Application < Sinatra::Application
    set :public_folder, File.dirname(__FILE__) + '/assets'

    get '/' do
      haml :index
    end

    get '/top_hundred' do
      haml :top_hundred, locals: { top_hundred: UrlShortener.new(url: params[:url], request_host: request.host,
                                                                 request_scheme: request.scheme,
                                                                 port: request.port).top_hundred }
    end

    post '/shorten' do
      json UrlShortener.new(url: params[:url], request_host: request.host, request_scheme: request.scheme,
                            port: request.port).response
    end

    get %r{^/(#{AccessTokens::ACCESS_TOKEN_EXPRESSION})$} do
      captured_token = params[:captures].first
      source_url = UrlShortener.access_url_by_token(captured_token)
      if source_url
        redirect source_url
      else
        status 404
        haml :error, locals: { error_message: "Oops! We weren't able to find a URL for #{captured_token} :("}
      end
    end
  end
end
