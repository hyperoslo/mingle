module Mingle::Instagram

  def self.table_name_prefix
    "#{Mingle.table_name_prefix}instagram_"
  end

  def self.fetch hashtags = Mingle::Hashtag.all
    hashtags = Array(hashtags)

    hashtags.each.map do |hashtag|
      Instagram.tag_recent_media(hashtag.tag_name_without_hash).collect do |media|

        case media.type
        when 'image'
          photo = Photo.find_or_initialize_by photo_id: media.id
          photo.attributes = {
            created_at: Time.at(media.created_time.to_i),
            link: media.link,
            message: media.try(:caption).try(:text),
            url: media.images.standard_resolution.url,
            user_handle: media.user.username,
            user_id: media.user.id,
            user_image_url: media.user.profile_picture,
            user_name: media.user.full_name
          }

          photo.hashtags << hashtag unless photo.hashtags.include? hashtag

          next if ignore? photo

          photo.save!
          photo
        end
      end.compact
    end.flatten
  end

  private

  # Determine whether the given photo should be ignored.
  #
  # photo - A Photo instance.
  #
  # Returns a Boolean.
  def self.ignore? photo
    include_rejected_word?(photo.message) || 
      rejected_user?(photo.user_handle) ||
      created_before?(photo, Mingle.config.since)
  end

  # TODO: Refactor to Photo
  def self.created_before?(photo, date)
    return false unless date

    photo.created_at < Mingle.config.since
  end

  # TODO: Refactor to Photo
  def self.include_rejected_word?(message)
    return false unless message

    message.split(' ').inject(true) do |bool, word|
      bool && Mingle.config.instagram_reject_words.include?(word.downcase)
    end
  end

  def self.rejected_user?(user)
    Mingle.config.instagram_reject_users.include? user
  end
end
