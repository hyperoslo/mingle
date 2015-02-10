# encoding: utf-8

require 'spec_helper'

describe Mingle::Twitter do
  before do
    Mingle.configure do |config|
      config.twitter_api_key = '...'
      config.twitter_api_secret = '...'
      config.twitter_access_token = '...'
      config.twitter_access_token_secret = '...'
      config.twitter_ignore_retweets = false
      config.twitter_reject_words = []
      config.twitter_reject_users = []
    end
  end

  let(:hashtag) { create :mingle_hashtag, tag_name: '#klhd' }

  it 'should prefix the database table name of namespaced models' do
    expect(Mingle::Twitter.table_name_prefix).to eq 'mingle_twitter_'
  end

  describe 'calls TweetsFetcher' do

    let(:tweets_fetcher) { instance_spy(Mingle::Twitter::TweetsFetcher) }

    it 'fetch tweets for hashtag' do
      expect(Mingle::Twitter::TweetsFetcher).to receive(:new).
        with(hashtag, {since_id: nil}).and_return(tweets_fetcher)

      Mingle::Twitter.fetch hashtag

      expect(tweets_fetcher).to have_received(:fetch)
    end

    it 'includes since_id option' do
      expect(Mingle::Twitter::TweetsFetcher).to receive(:new).
        with(hashtag, {since_id: 12345}).and_return(tweets_fetcher)

      Mingle::Twitter.fetch hashtag, 12345
    end

    it 'includes reject retweets option' do
      Mingle.temporarily(twitter_ignore_retweets: true) do
        expect(Mingle::Twitter::TweetsFetcher).to receive(:new).
          with(hashtag, {since_id: nil, exclude: 'retweets'}).
          and_return(tweets_fetcher)

        Mingle::Twitter.fetch hashtag
      end

    end

  end
end
