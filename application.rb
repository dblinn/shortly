require 'sinatra'
require 'sinatra/reloader' if development?

module Shortly
  class Application < Sinatra::Application
    get '/' do
      'Hello world!'
    end

    get '/top_hundred' do
      'This is a placeholder for the top 100'
    end
  end
end
