require 'spec_helper'

describe Mingle::Configuration do
  {
    facebook_access_token: 'FACEBOOK_ACCESS_TOKEN',
    twitter_api_key: 'TWITTER_API_KEY',
    twitter_api_secret: 'TWITTER_API_SECRET',
    twitter_access_token: 'TWITTER_ACCESS_TOKEN',
    twitter_access_token_secret: 'TWITTER_ACCESS_TOKEN_SECRET',
    instagram_client_id: 'INSTAGRAM_CLIENT_ID'
  }.each do |key, value|
    before { ENV[value] = 'some-environment-secret' }

    it "responds to #{key}=" do
      expect(subject).to respond_to "#{key}=".to_sym
    end

    it "responds to #{key}" do
      expect(subject).to respond_to key
    end

    describe '##{key}' do
      context 'when it is not configured through Mingle.configure' do
        it "fetches the configuration from the #{value} environment variable" do
          expect(subject.send(key)).to eq 'some-environment-secret'
        end
      end

      context 'when it has been configured through Mingle' do
        before do
          subject.send "#{key}=", 'some-configured-secret'
        end

        it 'fetches the configuration from the configuration' do
          expect(subject.send(key)).to eq 'some-configured-secret'
        end
      end
    end
  end
end
