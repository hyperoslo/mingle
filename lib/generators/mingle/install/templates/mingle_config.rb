Mingle.configure do |config|
  config.facebook_access_token       = ENV['FACEBOOK_ACCESS_TOKEN']
  config.twitter_api_key             = ENV['TWITTER_API_KEY']
  config.twitter_api_secret          = ENV['TWITTER_API_SECRET']
  config.twitter_access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.twitter_access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  config.instagram_client_id         = ENV['INSTAGRAM_CLIENT_ID']
end
