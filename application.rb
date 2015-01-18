require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'sinatra/json'

module Shortly
  class Application < Sinatra::Application
    set :public_folder, File.dirname(__FILE__) + '/assets'

    get '/' do
      haml :index
    end

    get '/top_hundred' do
      'This is a placeholder for the top 100'
    end

    post '/shorten' do
      json ok: 200
    end
  end
end
