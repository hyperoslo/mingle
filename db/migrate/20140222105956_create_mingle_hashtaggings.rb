class CreateMingleHashtaggings < ActiveRecord::Migration
  def change
    create_table :mingle_hashtaggings do |t|
      t.references :hashtag, index: true
      t.references :hashtaggable, polymorphic: true

      t.timestamps
    end

    add_index "mingle_hashtaggings", ["hashtaggable_id", "hashtaggable_type", "hashtag_id"], name: "unique_hashtagging", unique: true, using: :btree
    add_index "mingle_hashtaggings", ["hashtaggable_id", "hashtaggable_type"], name: "index_mingle_hashtaggings_on_hashtaggabe", using: :btree
  end
end
