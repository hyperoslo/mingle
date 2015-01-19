module Mingle::Twitter

  class << self

    def table_name_prefix
      "#{Mingle.table_name_prefix}twitter_"
    end

    def fetch hashtags = Mingle::Hashtag.all, since_id = Mingle::Twitter::Tweet.ordered.last.try(:tweet_id)
      hashtags = Array(hashtags)

      options = { since_id: since_id }
      options[:exclude] = 'retweets' if Mingle.config.twitter_ignore_retweets

      hashtags.map do |hashtag|
        client.search(query_string(hashtag), options).collect do |data|
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
      tweet.created_before?(Mingle.config.since)
    end

    # Builds query string for Tweet search.
    #
    # Returns a String.
    def query_string(hashtag)
      hashtag.tag_name_with_hash +
        rejected_words_string +
        rejected_users_string
    end

    # Builds rejected words query string for Tweet search.
    #
    # Returns a String.
    def rejected_words_string
      Mingle.config.twitter_reject_words.map {|w| " -#{w}"}.join
    end

    # Builds rejected users query string for Tweet search.
    #
    # Returns a String.
    def rejected_users_string
      Mingle.config.twitter_reject_users.map {|w| " -from:#{w}"}.join
    end
  end

end
