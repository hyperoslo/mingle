class Mingle::Instagram::Photo < ActiveRecord::Base
  has_many :hashtaggings, class_name: 'Mingle::Hashtagging', as: :hashtaggable, dependent: :destroy
  has_many :hashtags, through: :hashtaggings

  validates :link, :photo_id, :url, :user_handle, :user_image_url, presence: true

  scope :ordered, lambda { order('created_at ASC') }

  before_save :ensure_https_urls

  def author
    user_handle
  end

  def avatar
    user_image_url
  end

  private

  def ensure_https_urls
    self.link = link.sub(/http:/, 'https:')
    self.url = url.sub(/http:/, 'https:')
    self.user_image_url = user_image_url.sub(%r(http://images\.ak\.instagram\.com),
                                              'https://distillery.s3.amazonaws.com')
  end

end
