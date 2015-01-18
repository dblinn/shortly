require './spec/spec_helper'
require './lib/url_shortener'

describe 'Shortly::UrlShortener' do

  subject(:shortener) { Shortly::UrlShortener.new(url: 'www.nytimes.com') }

  it 'sets the url' do
    expect(shortener.url).to eq 'www.nytimes.com'
  end

  it 'produces a hash response' do
    response = shortener.response

    expect(response).to_not be_nil
    expect(response).to eq({ success: true, errors: [], original_url: 'www.nytimes.com', short_url: 'shorter' })
  end

end