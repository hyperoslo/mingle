require 'spec_helper'

describe Mingle::Twitter::Tweet do
  describe "#author" do
    it 'should be the user handle' do
      expect(subject.author).to eq subject.user_handle
    end
  end

  describe "#avatar" do
    it 'should be the user image url' do
      expect(subject.avatar).to eq subject.user_image_url
    end
  end

  describe "#url" do
    it 'should be the tweet url' do
      subject.stub(:user_handle).and_return 'sindre'
      subject.stub(:tweet_id).and_return '1337'
      expect(subject.url).to eq "https://twitter.com/sindre/status/1337"
    end
  end
end
