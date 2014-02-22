class Mingle::Hashtag < ActiveRecord::Base

  has_many :hashtaggings, class_name: 'Mingle::Hashtagging', dependent: :destroy

  has_many :facebook_posts,   through: :hashtaggings, source: :hashtaggable,
    source_type: 'Mingle::Facebook::Post'

  has_many :twitter_tweets,   through: :hashtaggings, source: :hashtaggable,
    source_type: 'Mingle::Twitter::Tweet'

  has_many :instagram_photos, through: :hashtaggings, source: :hashtaggable,
    source_type: 'Mingle::Instagram::Photo'

  validates :tag_name, uniqueness: true, presence: true

  def tag_name_with_hash
    return tag_name if tag_name.start_with? "#"

    "##{tag_name}"
  end

  def tag_name_without_hash
    return tag_name unless tag_name.start_with? "#"

    tag_name[1..-1]
  end

  def usage_count
    hashtaggings.count
  end
end
