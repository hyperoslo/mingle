class CreateMingleInstagramPhotos < ActiveRecord::Migration
  def change
    create_table :mingle_instagram_photos do |t|
      t.string :photo_id
      t.string :url
      t.string :link
      t.string :user_id
      t.string :user_handle
      t.string :user_image_url
      t.text :message

      t.timestamps
    end
  end
end
