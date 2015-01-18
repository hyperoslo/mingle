module Mingle::Concerns::Models::Instagram::Photo
  extend ActiveSupport::Concern

  included do
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

    def created_before?(date)
      return false unless date

      created_at < date
    end

    def rejected_user?(rejected_users)
      rejected_users.include? user_handle
    end

    def include_rejected_word?(rejected_words)
      return false if !message || message.empty?

      message.split(' ').inject(true) do |bool, word|
        bool && rejected_words.include?(word.downcase)
      end
    end
  end
end
