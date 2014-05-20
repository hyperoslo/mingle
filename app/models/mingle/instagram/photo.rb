class Mingle::Instagram::Photo < ActiveRecord::Base
  has_many :hashtaggings, class_name: 'Mingle::Hashtagging', as: :hashtaggable, dependent: :destroy
  has_many :hashtags, through: :hashtaggings

  validates :link, :photo_id, :url, :user_handle, :user_image_url, presence: true

  scope :ordered, lambda { order('created_at ASC') }

  def author
    user_handle
  end

  def avatar
    user_image_url
  end
end
