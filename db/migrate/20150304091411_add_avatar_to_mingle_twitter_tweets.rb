class AddAvatarToMingleTwitterTweets < ActiveRecord::Migration
  def change
    add_column :mingle_twitter_tweets, :avatar_id, :string
  end
end
