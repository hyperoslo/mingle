class Mingle::Facebook::Post < ActiveRecord::Base
  has_many :hashtaggings, class_name: 'Mingle::Hashtagging', as: :hashtaggable,
    dependent: :destroy

  has_many :hashtags, through: :hashtaggings

  validates :post_id, :user_id, :user_name, presence: true

  scope :ordered, lambda { order('created_at ASC') }

  # Prevent Rails from assuming :type is STI-related
  # See: http://stackoverflow.com/questions/7134559/rails-use-type-column-without-sti
  self.inheritance_column = nil

  # Large pictures are not directly provided through the Graph API
  # Note: Not a documented Facebook feature and may potentially break in the future
  def large_picture
    picture.gsub(/_(?:s|t)\.(jpg|jpeg|png|gif)$/, '_b.\1') if picture.present?
  end

  def profile_url
    "https://www.facebook.com/#{user_id}" if user_id.present?
  end

  def profile_image_url
    "https://graph.facebook.com/#{user_id}/picture" if user_id.present?
  end
end
