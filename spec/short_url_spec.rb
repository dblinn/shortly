require './spec/spec_helper'
require './spec/mongoid_spec_helper'
require './models/short_url'

module Shortly
  describe 'ShortUrl' do
    let(:source_url) { 'http://www.nytimes.com' }
    let(:short_url) { ShortUrl.find_or_create_by(source_url: source_url) }

    describe '#scopes' do
      it 'should find short urls with access tokens' do
        expect(ShortUrl.with_access_token(short_url.access_token).first).to eq short_url
      end

      it 'should order the top hundred urls descending by times accessed' do
        first_short_url = short_url
        second_short_url = ShortUrl.find_or_create_by(source_url: 'http://www.facebook.com')
        second_short_url.increment_times_accessed

        expect(ShortUrl.top_hundred).to eq [second_short_url, first_short_url]
      end
    end

    describe '#find_or_create_by_source_url' do
      it 'should generate a valid access token' do
        expect(AccessTokens.valid?(short_url.access_token)).to be_truthy
      end

      it 'should set the correct defaults' do
        expect(short_url.source_url).to eq source_url
        expect(short_url.times_accessed).to eq 0
        expect(short_url.times_shortened).to eq 1
        expect(short_url.last_shortened_time).to be <= Time.current
        expect(short_url.last_accessed_time).to be <= Time.current
      end

      it 'should not change the access token when the short_url already exists' do
        second_url = ShortUrl.find_or_create_by(source_url: source_url)
        expect(second_url.access_token).to eq short_url.access_token
      end
    end

    describe '#increment_times_accessed' do

      it 'should increment the times accessed count' do
        expect(short_url.times_accessed).to eq 0
        short_url.increment_times_accessed
        expect(ShortUrl.find_by(source_url: source_url).times_accessed).to eq 1
        short_url.increment_times_accessed
        expect(ShortUrl.find_by(source_url: source_url).times_accessed).to eq 2
      end

      it 'should update the last accessed time' do
        original_access_time = short_url.last_accessed_time
        short_url.increment_times_accessed
        expect(ShortUrl.find_by(source_url: source_url).last_accessed_time).to be > original_access_time
      end
    end

    describe '#increment_times_shortened' do
      it 'should increment the times shortened count' do
        expect(short_url.times_shortened).to eq 0
        short_url.increment_times_shortened
        expect(ShortUrl.find_by(source_url: source_url).times_shortened).to eq 1
        short_url.increment_times_shortened
        expect(ShortUrl.find_by(source_url: source_url).times_shortened).to eq 2
      end

      it 'should update the last shortened time' do
        original_shorten_time = short_url.last_shortened_time
        short_url.increment_times_shortened
        expect(ShortUrl.find_by(source_url: source_url).last_shortened_time).to be > original_shorten_time
      end
    end
  end
end