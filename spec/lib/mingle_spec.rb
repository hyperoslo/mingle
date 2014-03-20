require 'spec_helper'

describe Mingle do
  describe '.temporarily' do
    before do
      Mingle.configure { |config| config.facebook_access_token = 'original access token' }
    end

    it 'sets temporary configuration options' do
      Mingle.temporarily facebook_access_token: 'new access token' do
        expect(Mingle.config.facebook_access_token).to eq 'new access token'
      end

      expect(Mingle.config.facebook_access_token).to eq 'original access token'
    end
  end
end
