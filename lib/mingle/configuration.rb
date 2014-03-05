module Mingle
  class Configuration
    configs = [
      :facebook_access_token, :twitter_api_key, :twitter_api_secret,
      :twitter_access_token, :twitter_access_token_secret, :instagram_client_id
    ]

    attr_accessor *configs

    configs.each do |config|
      define_method config do
        instance_variable_get("@#{config}") || ENV[config.upcase.to_s]
      end
    end
  end
end
