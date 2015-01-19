require './spec/spec_helper'
require './lib/url_shortener'

describe 'Shortly::UrlShortener' do

  subject(:shortener) { Shortly::UrlShortener.new(url: 'http://www.nytimes.com', request_host: 'localhost', request_scheme: 'http') }

  it 'sets the url' do
    expect(shortener.url).to eq 'http://www.nytimes.com'
  end

  it 'produces a hash response' do
    expect(shortener).to receive(:short_url) { 'http://localhost/shorter' }
    response = shortener.response

    expect(response).to_not be_nil
    expect(response).to eq({ success: true, original_url: 'http://www.nytimes.com', short_url: 'http://localhost/shorter' })
  end

  describe '#valid' do
    it 'should consider a string invalid if it does not begin with http:// or https://' do
      expect(Shortly::UrlShortener.new(url: 'x', request_host: 'localhost', request_scheme: 'http').valid?).to be_falsey
      expect(Shortly::UrlShortener.new(url: 'http://x', request_host: 'localhost', request_scheme: 'http').valid?).to be_truthy
      expect(Shortly::UrlShortener.new(url: 'https://x', request_host: 'localhost', request_scheme: 'http').valid?).to be_truthy
    end

    it 'should consider a string invalid if it contains a non-escaped reserved character' do
      expect(Shortly::UrlShortener.new(url: 'http://example.com/?a=\11\15',
                                       request_host: 'localhost', request_scheme: 'http').valid?).to be_falsey
    end

    it 'should allow escaped reserved characters' do
      expect(Shortly::UrlShortener.new(url: URI::escape('http://example.com/?a=\11\15'),
                                                        request_host: 'localhost', request_scheme: 'http').valid?).to be_truthy
    end
  end
end