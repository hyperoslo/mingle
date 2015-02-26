module Mingle::Twitter


  def self.table_name_prefix
    "#{Mingle.table_name_prefix}twitter_"
  end

  def self.fetch hashtags = Mingle::Hashtag.all, since_id = Mingle::Twitter::Tweet.ordered.last.try(:tweet_id)
    hashtags = Array(hashtags)

    options = { since_id: since_id }
    options[:exclude] = 'retweets' if Mingle.config.twitter_ignore_retweets

    hashtags.flat_map do |hashtag|
      TweetsFetcher.new(hashtag, options).fetch
    end
  end
end
