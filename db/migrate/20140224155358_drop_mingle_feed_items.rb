class DropMingleFeedItems < ActiveRecord::Migration
  def change
    drop_table :mingle_feed_items
  end
end
