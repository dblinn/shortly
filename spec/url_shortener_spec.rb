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
      expect(shortener).to receive(:short_url_string) { 'http://localhost/shorter' }
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

      it 'should not allow shortening own urls that do not exist' do
        access_token = AccessTokens.generate
        expect(ShortUrl).to receive(:find_by) { nil }
        shortener = UrlShortener.new(url: "http://localhost:3000/#{access_token}",
                                     request_host: 'localhost', request_scheme: 'http', port: 3000)
        expect(shortener.valid?).to be_falsey
      end
    end
  
    describe '#short_url_string' do
      context 'valid' do
        let(:access_token) { AccessTokens.generate }
        before(:each) do
          expect(ShortUrl).to receive(:find_or_create_by) { double(access_token: access_token, increment_times_shortened: nil) }
        end

        it 'should create a short url consisting of the scheme, host, and access token' do
          shortener = UrlShortener.new(url: 'http://www.nytimes.com', request_host: 'localhost', request_scheme: 'http')
          expect(shortener.short_url_string).to eq "http://localhost/#{access_token}"
        end

        it 'should create a short url consisting of the scheme, host, port and access token' do
          shortener = UrlShortener.new(url: 'http://www.nytimes.com', request_host: 'localhost', request_scheme: 'http', port: 3000)
          expect(shortener.short_url_string).to eq "http://localhost:3000/#{access_token}"
        end

        it 'should not specify a port if the port is given as default http port' do
          shortener = UrlShortener.new(url: 'http://www.nytimes.com', request_host: 'localhost', request_scheme: 'http', port: 80)
          expect(shortener.short_url_string).to eq "http://localhost/#{access_token}"
        end

        it 'should not specify a port if the port is given as default https port' do
          shortener = UrlShortener.new(url: 'http://www.nytimes.com', request_host: 'localhost', request_scheme: 'http', port: 443)
          expect(shortener.short_url_string).to eq "http://localhost/#{access_token}"
        end
      end

      context 'invalid' do
        it 'should not generate a short url for an invalid source url' do
          shortener = UrlShortener.new(url: 'this is invalid', request_host: 'localhost', request_scheme: 'http', port: 443)
          expect(shortener.short_url_string).to be_nil
        end
      end
    end

    describe '#source_url_string' do
      let(:access_token) { AccessTokens.generate }
      let(:source_url) { 'http://www.nytimes.com' }

      context 'valid' do
        let(:original_url) { "http://localhost:3000/#{access_token}" }

        it 'should return the associated source url' do
          expect(ShortUrl).to receive(:find_by) { double(access_token: access_token, increment_times_shortened: nil, source_url: source_url) }
          shortener = UrlShortener.new(url: original_url, request_host: 'localhost', request_scheme: 'http', port: 3000)
          expect(shortener.source_url_string).to eq source_url
        end

        context 'token not found' do
          it 'should return the original source url' do
            expect(ShortUrl).to receive(:find_by) { nil }
            shortener = UrlShortener.new(url: original_url, request_host: 'localhost', request_scheme: 'http', port: 3000)
            expect(shortener.source_url_string).to eq original_url
          end
        end
      end

      context 'not own url' do
        let(:original_url) { "http://localhost:3000/#{access_token[0..6]}" }

        it 'should return the original source url' do
          expect(ShortUrl).to_not receive(:find_by) { nil }
          shortener = UrlShortener.new(url: original_url, request_host: 'localhost', request_scheme: 'http', port: 3000)
          expect(shortener.source_url_string).to eq original_url
        end
      end
    end

    describe '#own_url?' do
      let(:access_token) { AccessTokens.generate }

      it 'should consider urls with the correct scheme, host, and port own url' do
        shortener = UrlShortener.new(url: "http://localhost:3000/#{access_token}",
                                     request_host: 'localhost', request_scheme: 'http', port: 3000)
        expect(shortener.own_url?).to be_truthy
      end

      context 'http port' do
        it 'should accept the port param for the http port' do
          shortener = UrlShortener.new(url: "http://localhost:80/#{access_token}",
                                       request_host: 'localhost', request_scheme: 'http', port: 80)
          expect(shortener.own_url?).to be_truthy
        end

        it 'should not require the port param for the http port' do
          shortener = UrlShortener.new(url: "http://localhost/#{access_token}",
                                       request_host: 'localhost', request_scheme: 'http', port: 80)
          expect(shortener.own_url?).to be_truthy
        end
      end

      context 'https port' do
        it 'should accept the port param for the https port' do
          shortener = UrlShortener.new(url: "http://localhost:443/#{access_token}",
                                       request_host: 'localhost', request_scheme: 'http', port: 443)
          expect(shortener.own_url?).to be_truthy
        end

        it 'should not require the port param for the https port' do
          shortener = UrlShortener.new(url: "http://localhost/#{access_token}",
                                       request_host: 'localhost', request_scheme: 'http', port: 443)
          expect(shortener.own_url?).to be_truthy
        end
      end
    end
  end
end