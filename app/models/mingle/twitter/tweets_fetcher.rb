module Mingle::Twitter
  class TweetsFetcher
    def initialize(hashtag, options)
      @hashtag = hashtag
      @options = options
    end

    def fetch
      valid_tweets.each {|t| t.save! }
    end

    private

    attr_reader :hashtag, :options

    def valid_tweets
      tweets_for_hashtag.reject {|t| ignore? t}
    end

    def tweets_for_hashtag
      tweetdata_for_hashtag.collect do |data|
        Tweet.find_or_initialize_by(tweet_id: data.id.to_s).tap do |tweet|
          tweet.attributes = {
            created_at: data.created_at,
            image_url: data.media.any? ? data.media.first.media_url_https.to_s : nil,
            text: data.text,
            user_id: data.user.id.to_s,
            user_handle: data.user.screen_name,
            # Twitter orignally only returns a small version of the profile image. 
            # by removing '_normal' at the end of the image link a large image is returned.
            remote_avatar_url: data.user.profile_image_url.to_s.gsub(/_normal/, ''),
            user_name: data.user.name
          }
          tweet.hashtags << hashtag unless tweet.hashtags.exists? hashtag
        end
      end
    end

    def tweetdata_for_hashtag
      client.search(query_string, options)
    end

    def ignore? tweet
      tweet.created_before?(Mingle.config.since)
    end

    def client
      Twitter::REST::Client.new do |config|
        config.consumer_key        = Mingle.config.twitter_api_key
        config.consumer_secret     = Mingle.config.twitter_api_secret
        config.access_token        = Mingle.config.twitter_access_token
        config.access_token_secret = Mingle.config.twitter_access_token_secret
      end
    end

    def query_string
      hashtag.tag_name_with_hash +
        rejected_words_string +
        rejected_users_string
    end

    def rejected_words_string
      Mingle.config.twitter_reject_words.map {|w| " -#{w}"}.join
    end

    def rejected_users_string
      Mingle.config.twitter_reject_users.map {|w| " -from:#{w}"}.join
    end
  end
end
