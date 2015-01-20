require_relative './spec_helper'
require_relative '../application'

module Shortly
  describe 'Application' do
    def app
      Application
    end

    describe 'GET "/"' do
      it 'serves the root url' do
        get '/'
        expect(last_response).to be_ok
        expect(last_response.body).to match('shorts-logo')
        expect(last_response.body).to match('/top_hundred')
      end
    end

    describe 'GET "/top_hundred"' do
      it 'serves the route for the top hundred' do
        get '/top_hundred'
        expect(last_response).to be_ok
      end
    end

    describe 'POST "/shorten"' do
      it 'serves the post route for url shortening' do
        post '/shorten', { url: 'www.nytimes.com' }
        expect(last_response).to be_ok
      end
    end

    describe 'GET by access token' do
      it 'should redirect to a source url' do
        redirect_location = 'http://www.nytimes.com'
        expect(UrlShortener).to receive(:access_url_by_token) { redirect_location }

        get '/3bwkbuoe'

        expect(last_response).to be_redirect
        expect(last_response.location).to eq redirect_location
      end

      it 'should go to an error page for an unknown access token' do
        access_token = '3bwkbuoe'
        get "/#{access_token}"

        expect(last_response.status).to eq 404
        expect(last_response.body).to match(access_token)
      end
    end
  end
end