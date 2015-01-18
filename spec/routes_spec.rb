require './spec/spec_helper'
require './application'

describe 'Shortly::Application' do
  def app
    Shortly::Application
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
      get '/'
      expect(last_response).to be_ok
    end
  end
end