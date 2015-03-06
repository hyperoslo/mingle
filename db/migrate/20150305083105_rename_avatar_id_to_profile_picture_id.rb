class RenameAvatarIdToProfilePictureId < ActiveRecord::Migration
  def change
    rename_column :mingle_twitter_tweets, :avatar_id, :profile_picture_id
    rename_column :mingle_instagram_photos, :avatar_id, :profile_picture_id
  end
end
