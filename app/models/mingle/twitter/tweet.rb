class Mingle::Twitter::Tweet < ActiveRecord::Base
  has_many :hashtaggings, class_name: 'Mingle::Hashtagging', as: :hashtaggable,
    dependent: :destroy

  has_many :hashtags, through: :hashtaggings

  validates :text, :tweet_id, :user_handle, :user_image_url, :user_name, presence: true

  scope :ordered, lambda { order('created_at ASC') }

  before_save :ensure_https_urls

  def author
    user_handle
  end

  def avatar
    user_image_url
  end

  def url
    "https://twitter.com/#{user_handle}/status/#{tweet_id}"
  end

  private

  def ensure_https_urls
    self.user_image_url = user_image_url.sub(/http:/, 'https:')
  end
end
