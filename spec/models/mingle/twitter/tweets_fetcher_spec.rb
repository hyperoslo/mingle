require 'spec_helper'

describe Mingle::Twitter::TweetsFetcher do
  let(:hashtag) { create :mingle_hashtag, tag_name: '#klhd' }
  let(:options) { {since_id: nil} }
  subject(:tweets_fetcher) { described_class.new(hashtag, options) }
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

  describe 'twitter client search' do
    let(:client) { double('Twitter client', search: double(collect: [])) }

    before do
      allow(tweets_fetcher).to receive(:client).and_return(client)
    end

    it 'can fetch tweets since the beginning of time' do
      tweets_fetcher.fetch

      expect(client).to have_received(:search).with("#klhd", since_id: nil)
    end


    it 'can fetch tweets and exclude words' do
      Mingle.config.twitter_reject_words = ['boobs']
      tweets_fetcher.fetch

      expect(client).to have_received(:search).with("#klhd -boobs", since_id: nil)
    end

    it 'can fetch tweets and exclude users' do
      Mingle.config.twitter_reject_users = ['rejectedUser']
      tweets_fetcher.fetch

      expect(client).to have_received(:search).with("#klhd -from:rejectedUser", since_id: nil)
    end

    describe 'with exclude retweets' do
      let(:options) { { since_id: nil, exclude: 'retweets' } }
      it 'can fetch tweets and ignore retweets' do
        Mingle.config.twitter_ignore_retweets = true
        tweets_fetcher.fetch

        expect(client).to have_received(:search).with("#klhd", exclude: 'retweets', since_id: nil)
      end
    end
    describe 'with since_id' do
      let(:options) { {since_id: 12391} }
      it 'can fetch tweets since last tweet by id' do
        tweets_fetcher.fetch

        expect(client).to have_received(:search).with("#klhd", since_id: 12391)
      end
    end

  end

  describe 'building tweet' do

    let(:tweets) { tweets_fetcher.fetch }

    before do
      stub_request(:get, /api.twitter.com\/1\.1\/search\/tweets\.json/).to_return body: fixture('mingle/twitter/tweets.json')
      stub_request(:get, /twimg.com/).to_return body: fixture('mingle/twitter/tim.oslo.png')
    end

    it 'will create model instances for fetched tweets' do
      tweet = tweets.first

      expect(tweet.created_at).to eq DateTime.parse('Sat Jun 01 07:45:37 +0000 2013')
      expect(tweet.text).to match /^Klar for dagens plikter! Ha en fin lørdag/
      expect(tweet.user_id).to eq '280615050'
      expect(tweet.user_handle).to eq 'anitairenLFC'
      expect(tweet.avatar).to eq 'http://si0.twimg.com/profile_images/3521212093/20a837ff967f5f1685f00506df7550e5_normal.jpeg'
      expect(tweet.user_name).to eq 'Anita Iren Vassli'
      expect(tweet.profile_picture).to be_a Refile::File

      tweet = tweets.last

      expect(tweet.created_at).to eq DateTime.parse('Sat Jun 01 07:33:40 +0000 2013')
      expect(tweet.text).to match /^Av erfaring er det en ting som er sikkert/
      expect(tweet.user_id).to eq '87887606'
      expect(tweet.user_handle).to eq 'Hbjorg'
      expect(tweet.avatar).to eq 'http://si0.twimg.com/profile_images/1364414120/Profil_twitter_normal.jpg'
      expect(tweet.user_name).to eq 'Hans Fredrik'
      expect(tweet.profile_picture).to be_a Refile::File

      expect(Mingle::Twitter::Tweet.count).to be 2
    end

    it 'associates hashtag models to the returned tweets' do
      stub_request(:get, /api.twitter.com\/1\.1\/search\/tweets\.json/).to_return body: fixture('mingle/twitter/tweets.json')

      tweet = tweets.first

      expect(tweet.hashtags).to eq [ hashtag ]
    end

    it 'will ignore tweets that are too old' do
      Mingle.temporarily(since: Time.now) do

        expect(tweets.count).to eq 0
      end
    end
  end

  describe 'ignoring tweets' do
    it 'should ignore tweets created before since configuration' do
      tweet_created_before = double('tweet created before', created_before?: true)
      tweet_created_after = double('tweet created after', created_before?: false, save!: true)
      allow(tweets_fetcher).to receive(:tweets_for_hashtag).and_return([tweet_created_after, tweet_created_before])
      expect(tweets_fetcher.fetch.count).to eq(1)
    end
  end

end
