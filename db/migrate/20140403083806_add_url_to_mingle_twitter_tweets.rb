class AddUrlToMingleTwitterTweets < ActiveRecord::Migration
  def change
    add_column :mingle_twitter_tweets, :url, :string
  end
end
