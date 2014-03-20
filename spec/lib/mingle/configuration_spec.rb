require 'spec_helper'

describe Mingle::Configuration do
  around do |example|
    Mingle.temporarily &example
  end

  after :all do
    ENVIRONMENT_ENABLED_CONFIGURATIONS.each { |key, value| ENV[key.to_s.upcase] = nil }
  end

  ENVIRONMENT_ENABLED_CONFIGURATIONS = {
    facebook_access_token: 'FACEBOOK_ACCESS_TOKEN',
    twitter_api_key: 'TWITTER_API_KEY',
    twitter_api_secret: 'TWITTER_API_SECRET',
    twitter_access_token: 'TWITTER_ACCESS_TOKEN',
    twitter_access_token_secret: 'TWITTER_ACCESS_TOKEN_SECRET',
    instagram_client_id: 'INSTAGRAM_CLIENT_ID',
  }

  NON_ENVIRONMENT_ENABLED_CONFIGURATIONS = {
    since: 2.days.ago
  }

  CONFIGURATIONS = ENVIRONMENT_ENABLED_CONFIGURATIONS.merge NON_ENVIRONMENT_ENABLED_CONFIGURATIONS

  CONFIGURATIONS.each do |key, value|
    it "responds to #{key}=" do
      expect(subject).to respond_to "#{key}=".to_sym
    end

    it "responds to #{key}" do
      expect(subject).to respond_to key
    end

    describe '##{key}' do
      context 'when it is not configured through Mingle.configure' do
        before { ENV[key.to_s.upcase] = 'some-environment-secret' }

        it "fetches the configuration from the #{value} environment variable" do
          expect(subject.send(key)).to eq 'some-environment-secret'
        end
      end unless key.in? NON_ENVIRONMENT_ENABLED_CONFIGURATIONS

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
