class AddUserNameToMingleInstagramPhotos < ActiveRecord::Migration
  def change
    add_column :mingle_instagram_photos, :user_name, :string
  end
end
