module Mingle::Twitter

  class << self

    def table_name_prefix
      "#{Mingle.table_name_prefix}twitter_"
    end

    # Fetch tweets for #klhd since given tweet ID, last stored tweet ID or beginning of time
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

          tweet.save!
          tweet
        end
      end.flatten
    end

    # Initialize the Twitter client.
    #
    # Returns a new Twitter::REST::Client instance.
    def client
      Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_API_KEY']
        config.consumer_secret     = ENV['TWITTER_API_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end

  end

end
