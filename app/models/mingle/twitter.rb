module Mingle::Twitter

  class << self

    def table_name_prefix
      "#{Mingle.table_name_prefix}twitter_"
    end

    def fetch hashtags = Mingle::Hashtag.all, since_id = Mingle::Twitter::Tweet.ordered.last.try(:tweet_id)
      hashtags = Array(hashtags)

      hashtags.map do |hashtag|
        client.search(hashtag.tag_name_with_hash, since_id: since_id).collect do |data|
          tweet = Tweet.find_or_initialize_by tweet_id: data.id.to_s

          tweet.attributes = {
            created_at: data.created_at,
            image_url: data.media.any? ? data.media.first.media_url_https.to_s : nil,
            text: data.text,
            user_id: data.user.id.to_s,
            user_handle: data.user.screen_name,
            user_image_url: data.user.profile_image_url.to_s,
            user_name: data.user.name
          }

          tweet.hashtags << hashtag unless tweet.hashtags.include? hashtag

          next if ignore? tweet

          tweet.save!
          tweet
        end.compact
      end.flatten
    end

    # Initialize the Twitter client.
    #
    # Returns a new Twitter::REST::Client instance.
    def client
      Twitter::REST::Client.new do |config|
        config.consumer_key        = Mingle.config.twitter_api_key
        config.consumer_secret     = Mingle.config.twitter_api_secret
        config.access_token        = Mingle.config.twitter_access_token
        config.access_token_secret = Mingle.config.twitter_access_token_secret
      end
    end

    # Determine whether the given tweet should be ignored.
    #
    # tweet - A Tweet instance.
    #
    # Returns a Boolean.
    def ignore? tweet
      Mingle.config.since && tweet.created_at < Mingle.config.since
    end
  end

end
