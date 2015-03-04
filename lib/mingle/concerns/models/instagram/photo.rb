module Mingle::Concerns::Models::Instagram::Photo
  extend ActiveSupport::Concern

  included do
    attachment :avatar

    has_many :hashtaggings, class_name: 'Mingle::Hashtagging', as: :hashtaggable, dependent: :destroy
    has_many :hashtags, through: :hashtaggings

    validates :link, :photo_id, :url, :user_handle, presence: true

    scope :ordered, lambda { order('created_at ASC') }

    def author
      user_handle
    end

    def created_before?(date)
      return false unless date

      created_at < date
    end

    def rejected_user?(rejected_users)
      rejected_users.include? user_handle
    end

    def include_rejected_word?(rejected_words)
      rejected_words.select! {|w| w && !w.empty? }

      return false if !message? || rejected_words.empty?

      rejected_words.any? {|w| message.match(/\b(#{w})\b/i) }
    end
  end
end
