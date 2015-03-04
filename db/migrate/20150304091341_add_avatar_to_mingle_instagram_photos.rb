class AddAvatarToMingleInstagramPhotos < ActiveRecord::Migration
  def change
    add_column :mingle_instagram_photos, :avatar_id, :string
  end
end
