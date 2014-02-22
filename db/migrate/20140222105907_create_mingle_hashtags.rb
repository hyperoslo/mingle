class CreateMingleHashtags < ActiveRecord::Migration
  def change
    create_table :mingle_hashtags do |t|
      t.string :tag_name

      t.timestamps
    end
  end
end
