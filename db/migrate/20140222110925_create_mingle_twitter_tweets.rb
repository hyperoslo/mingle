class CreateMingleTwitterTweets < ActiveRecord::Migration
  def change
    create_table :mingle_twitter_tweets do |t|
      t.string :tweet_id
      t.string :user_id
      t.string :user_handle
      t.string :user_image_url
      t.string :text
      t.string :user_name
      t.string :image_url

      t.timestamps
    end
  end
end
