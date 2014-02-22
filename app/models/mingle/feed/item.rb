class Mingle::Feed::Item < ActiveRecord::Base
  belongs_to :feedable, polymorphic: true, inverse_of: :feed_items

  validates :feedable, presence: true

  default_scope { order('sticky DESC').order('created_at DESC') }
  scope :published, lambda { where(published: true) }
end
