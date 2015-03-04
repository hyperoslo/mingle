require 'spec_helper'

describe Mingle::Twitter::Tweet do
  describe "#author" do
    it 'should be the user handle' do
      expect(subject.author).to eq subject.user_handle
    end
  end

  describe "#avatar" do
    it 'should be the user image url' do
      #pending 'need to test that there is an avatar'
      #expect(subject.avatar).to eq subject.user_image_url
    end
  end

  describe "#url" do
    it 'should be the tweet url' do
      subject.stub(:user_handle).and_return 'sindre'
      subject.stub(:tweet_id).and_return '1337'
      expect(subject.url).to eq "https://twitter.com/sindre/status/1337"
    end
  end

  describe "#created_before?" do
    it 'should return true' do
      tweet = described_class.new(created_at: 1.day.ago)
      expect(tweet.created_before?(Date.current)).to eq(true)
    end

    it 'should return false' do
      tweet = described_class.new(created_at: 1.day.ago)
      expect(tweet.created_before?(2.day.ago)).to eq(false)
    end

    it 'should return false when date is nil' do
      tweet = described_class.new(created_at: 1.day.ago)
      expect(tweet.created_before?(nil)).to eq(false)
    end
  end
end
