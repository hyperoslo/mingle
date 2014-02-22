class Mingle::Twitter::Tweet < ActiveRecord::Base

  has_many :feed_items, class_name: 'Mingle::Feed::Item', as: :feedable,
    inverse_of: :feedable, dependent: :destroy

  has_many :hashtaggings, class_name: 'Mingle::Hashtagging', as: :hashtaggable,
    dependent: :destroy

  has_many :hashtags, through: :hashtaggings

  validates :text, :tweet_id, :user_handle, :user_image_url, :user_name, presence: true

  scope :ordered, lambda { order('created_at ASC') }

  before_save :ensure_https_urls

  private

  def ensure_https_urls
    self.user_image_url = user_image_url.sub(/http:/, 'https:')
  end
end
