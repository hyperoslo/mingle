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
    photo.include_rejected_word?(Mingle.config.instagram_reject_words) || 
      photo.rejected_user?(Mingle.config.instagram_reject_users) ||
      photo.created_before?(Mingle.config.since)
  end

end
