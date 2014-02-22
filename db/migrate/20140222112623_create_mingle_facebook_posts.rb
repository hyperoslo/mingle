class CreateMingleFacebookPosts < ActiveRecord::Migration
  def change
    create_table :mingle_facebook_posts do |t|
      t.string :post_id
      t.text :message
      t.text :link
      t.text :picture
      t.string :name
      t.text :caption
      t.text :description
      t.string :type
      t.string :user_id
      t.string :user_name

      t.timestamps
    end
    add_index :mingle_facebook_posts, :post_id
  end
end
