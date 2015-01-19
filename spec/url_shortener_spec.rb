require './spec/spec_helper'
require './lib/url_shortener'
require './models/short_url'

module Shortly
  describe 'UrlShortener' do
  
    subject(:shortener) { UrlShortener.new(url: 'http://www.nytimes.com', request_host: 'localhost', request_scheme: 'http') }
  
    it 'sets the url' do
      expect(shortener.url).to eq 'http://www.nytimes.com'
    end
  
    it 'produces a hash response' do
      expect(shortener).to receive(:short_url) { 'http://localhost/shorter' }
      response = shortener.response
  
      expect(response).to_not be_nil
      expect(response).to eq({ success: true, source_url: 'http://www.nytimes.com', short_url: 'http://localhost/shorter' })
    end
  
    describe '#valid' do
      it 'should consider a string invalid if it does not begin with http:// or https://' do
        expect(UrlShortener.new(url: 'x', request_host: 'localhost', request_scheme: 'http').valid?).to be_falsey
        expect(UrlShortener.new(url: 'http://x', request_host: 'localhost', request_scheme: 'http').valid?).to be_truthy
        expect(UrlShortener.new(url: 'https://x', request_host: 'localhost', request_scheme: 'http').valid?).to be_truthy
      end
  
      it 'should consider a string invalid if it contains a non-escaped reserved character' do
        expect(UrlShortener.new(url: 'http://example.com/?a=\11\15',
                                         request_host: 'localhost', request_scheme: 'http').valid?).to be_falsey
      end
  
      it 'should allow escaped reserved characters' do
        expect(UrlShortener.new(url: URI::escape('http://example.com/?a=\11\15'),
                                                          request_host: 'localhost', request_scheme: 'http').valid?).to be_truthy
      end
    end
  
    describe '#short_url' do
      let(:access_token) { AccessTokens.generate }
      before(:each) do
        expect(ShortUrl).to receive(:find_or_create_by) { double(access_token: access_token, increment_times_shortened: nil) }
      end
  
      it 'should create a short url consisting of the scheme, host, and access token' do
        shortener = UrlShortener.new(url: 'http://www.nytimes.com', request_host: 'localhost', request_scheme: 'http')
        expect(shortener.short_url).to eq "http://localhost/#{access_token}"
      end

      it 'should create a short url consisting of the scheme, host, port and access token' do
        shortener = UrlShortener.new(url: 'http://www.nytimes.com', request_host: 'localhost', request_scheme: 'http', port: 3000)
        expect(shortener.short_url).to eq "http://localhost:3000/#{access_token}"
      end

      it 'should not specify a port if the port is given as default http port' do
        shortener = UrlShortener.new(url: 'http://www.nytimes.com', request_host: 'localhost', request_scheme: 'http', port: 80)
        expect(shortener.short_url).to eq "http://localhost/#{access_token}"
      end

      it 'should not specify a port if the port is given as default https port' do
        shortener = UrlShortener.new(url: 'http://www.nytimes.com', request_host: 'localhost', request_scheme: 'http', port: 443)
        expect(shortener.short_url).to eq "http://localhost/#{access_token}"
      end
    end
  end
end