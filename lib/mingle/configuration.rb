module Mingle
  class Configuration
    configs = [
      :facebook_access_token, :twitter_api_key, :twitter_api_secret,
      :twitter_access_token, :twitter_access_token_secret,
      :twitter_ignore_retweets, :instagram_client_id, :since,
      :twitter_reject_words, :twitter_reject_users,
      :instagram_reject_words, :instagram_reject_users
    ]

    attr_accessor *configs

    def initialize
      @twitter_ignore_retweets = false
      @twitter_reject_words    = []
      @twitter_reject_users    = []
      @instagram_reject_words  = []
      @instagram_reject_users  = []
    end

    def facebook_access_token
      @facebook_access_token || ENV['FACEBOOK_ACCESS_TOKEN']
    end

    def twitter_api_key
      @twitter_api_key || ENV['TWITTER_API_KEY']
    end

    def twitter_api_secret
      @twitter_api_secret || ENV['TWITTER_API_SECRET']
    end

    def twitter_access_token
      @twitter_access_token || ENV['TWITTER_ACCESS_TOKEN']
    end

    def twitter_access_token_secret
      @twitter_access_token_secret || ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    def instagram_client_id
      @instagram_client_id || ENV['INSTAGRAM_CLIENT_ID']
    end
  end
end
