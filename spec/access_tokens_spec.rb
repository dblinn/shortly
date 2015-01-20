require_relative './spec_helper'
require_relative '../lib/access_tokens'

describe 'Shortly::AccessTokens' do
  describe '#generate' do
    it 'should generate strings' do
      expect(Shortly::AccessTokens.generate).to be_kind_of(String)
    end
  end

  describe '#valid' do
    it 'should validate lower-case alphanumeric strings of the correct length' do
      expect(Shortly::AccessTokens.valid?('12345678')).to be_truthy
    end

    it 'should invalidate strings of the incorrect length' do
      expect(Shortly::AccessTokens.valid?('123456789')).to be_falsey
    end

    it 'should invalidate strings with incorrect characters' do
      expect(Shortly::AccessTokens.valid?('1234567*')).to be_falsey
    end
  end

  context '#generate and #valid integration' do
    it 'should not generate invalid tokens' do
      # 1000000.times do
      100000.times do |i|
        expect(Shortly::AccessTokens.valid?(Shortly::AccessTokens.generate)).to be_truthy
      end
    end
  end
end
