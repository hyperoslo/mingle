# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150305083105) do

  create_table "mingle_facebook_posts", force: true do |t|
    t.string   "post_id"
    t.text     "message"
    t.text     "link"
    t.text     "picture"
    t.string   "name"
    t.text     "caption"
    t.text     "description"
    t.string   "type"
    t.string   "user_id"
    t.string   "user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mingle_facebook_posts", ["post_id"], name: "index_mingle_facebook_posts_on_post_id"

  create_table "mingle_hashtaggings", force: true do |t|
    t.integer  "hashtag_id"
    t.integer  "hashtaggable_id"
    t.string   "hashtaggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mingle_hashtaggings", ["hashtag_id"], name: "index_mingle_hashtaggings_on_hashtag_id"
  add_index "mingle_hashtaggings", ["hashtaggable_id", "hashtaggable_type", "hashtag_id"], name: "unique_hashtagging", unique: true
  add_index "mingle_hashtaggings", ["hashtaggable_id", "hashtaggable_type"], name: "index_mingle_hashtaggings_on_hashtaggabe"

  create_table "mingle_hashtags", force: true do |t|
    t.string   "tag_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mingle_instagram_photos", force: true do |t|
    t.string   "photo_id"
    t.string   "url"
    t.string   "link"
    t.string   "user_id"
    t.string   "user_handle"
    t.string   "user_image_url"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_name"
    t.string   "profile_picture_id"
  end

  create_table "mingle_twitter_tweets", force: true do |t|
    t.string   "tweet_id"
    t.string   "user_id"
    t.string   "user_handle"
    t.string   "user_image_url"
    t.string   "text"
    t.string   "user_name"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "profile_picture_id"
  end

end
