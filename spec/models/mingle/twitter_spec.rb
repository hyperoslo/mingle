# encoding: utf-8

require 'spec_helper'

describe Mingle::Twitter do
  let(:hashtag) { create :mingle_hashtag, tag_name: '#klhd' }

  before do
    Mingle.configure do |config|
      config.twitter_api_key = '...'
      config.twitter_api_secret = '...'
      config.twitter_access_token = '...'
      config.twitter_access_token_secret = '...'
      config.twitter_ignore_retweets = false
    end
  end

  it 'should prefix the database table name of namespaced models' do
    expect(Mingle::Twitter.table_name_prefix).to eq 'mingle_twitter_'
  end

  it 'can fetch tweets since the beginning of time' do
    Twitter::REST::Client.any_instance.should_receive(:search).with("#klhd", since_id: nil)
      .and_return double(collect: [])

    Mingle::Twitter.fetch hashtag
  end

  it 'can fetch tweets since last tweet by id' do
    Twitter::REST::Client.any_instance.should_receive(:search).with("#klhd", since_id: 12391)
      .and_return double(collect: [])

    Mingle::Twitter.fetch hashtag, 12391
  end

  it 'can fetch tweets and ignore retweets' do
    Mingle.config.twitter_ignore_retweets = true
    Twitter::REST::Client.any_instance.should_receive(:search).with("#klhd", exclude: 'retweets', since_id: nil)
      .and_return double(collect: [])

    Mingle::Twitter.fetch hashtag
  end

  it 'will create model instances for fetched tweets' do
    stub_request(:get, /api.twitter.com\/1\.1\/search\/tweets\.json/).to_return body: fixture('mingle/twitter/tweets.json')

    tweets = Mingle::Twitter.fetch hashtag

    tweet = tweets.first

    expect(tweet.created_at).to eq DateTime.parse('Sat Jun 01 07:45:37 +0000 2013')
    expect(tweet.text).to match /^Klar for dagens plikter! Ha en fin lørdag/
    expect(tweet.user_id).to eq '280615050'
    expect(tweet.user_handle).to eq 'anitairenLFC'
    expect(tweet.user_image_url).to eq 'http://si0.twimg.com/profile_images/3521212093/20a837ff967f5f1685f00506df7550e5_normal.jpeg'
    expect(tweet.user_name).to eq 'Anita Iren Vassli'

    tweet = tweets.last

    expect(tweet.created_at).to eq DateTime.parse('Sat Jun 01 07:33:40 +0000 2013')
    expect(tweet.text).to match /^Av erfaring er det en ting som er sikkert/
    expect(tweet.user_id).to eq '87887606'
    expect(tweet.user_handle).to eq 'Hbjorg'
    expect(tweet.user_image_url).to eq 'http://si0.twimg.com/profile_images/1364414120/Profil_twitter_normal.jpg'
    expect(tweet.user_name).to eq 'Hans Fredrik'

    expect(Mingle::Twitter::Tweet.count).to be 2
  end

  it 'associates hashtag models to the returned tweets' do
    stub_request(:get, /api.twitter.com\/1\.1\/search\/tweets\.json/).to_return body: fixture('mingle/twitter/tweets.json')

    tweets = Mingle::Twitter.fetch hashtag

    tweet = tweets.first

    expect(tweet.hashtags).to eq [ hashtag ]
  end

  it 'will ignore tweets that are too old' do
    stub_request(:get, /api.twitter.com\/1\.1\/search\/tweets\.json/).to_return body: fixture('mingle/twitter/tweets.json')

    Mingle.temporarily(since: Time.now) do
      tweets = Mingle::Twitter.fetch hashtag

      expect(tweets.count).to eq 0
    end
  end
end
