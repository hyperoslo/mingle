module Mingle::Instagram
  class PhotosFetcher
    def initialize(hashtag)
      @hashtag = hashtag

      Instagram.configure do |config|
        config.client_id = Mingle.config.instagram_client_id
      end
    end

    def fetch
      valid_photos.each {|p| p.save!}
    end

    private

    attr_reader :hashtag

    def valid_photos
      photos_for_hashtag.reject {|p| ignore? p }
    end

    def ignore? photo
      photo.include_rejected_word?(Mingle.config.instagram_reject_words) || 
        photo.rejected_user?(Mingle.config.instagram_reject_users) ||
        photo.created_before?(Mingle.config.since)
    end

    def photos_for_hashtag
      imagedata_for_hashtag.map  do |media| 
        Photo.find_or_initialize_by(photo_id: media.id).tap do |photo|
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
          photo.hashtags << hashtag unless photo.hashtags.exists? hashtag
        end
      end
    end

    def imagedata_for_hashtag
      Instagram.tag_recent_media(hashtag.tag_name_without_hash).
        select {|m| m.type == 'image'}
    end
  end
end
