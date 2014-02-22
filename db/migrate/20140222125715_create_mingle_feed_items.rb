class CreateMingleFeedItems < ActiveRecord::Migration
  def change
    create_table :mingle_feed_items do |t|
      t.references :feedable, polymorphic: true, index: true
      t.boolean :published, index: true, default: true
      t.boolean :sticky, index: true, default: false

      t.timestamps
    end
  end
end
