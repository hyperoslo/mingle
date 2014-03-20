require 'spec_helper'

describe Mingle do
  describe '.temporarily' do
    it 'sets temporary configuration options' do
      expect(Mingle.config.facebook_access_token).to be_nil

      Mingle.temporarily facebook_access_token: 'new access token' do
        expect(Mingle.config.facebook_access_token).to eq 'new access token'
      end

      expect(Mingle.config.facebook_access_token).to be_nil
    end
  end
end
