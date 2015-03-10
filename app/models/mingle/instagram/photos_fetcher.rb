require 'net/http'

module Mingle::Instagram
  class PhotosFetcher
    def initialize(hashtag)
      @hashtag = hashtag
      @recent_proccesed_media = []
      Instagram.configure do |config|
        config.client_id = Mingle.config.instagram_client_id
      end
    end

    def fetch
      valid_photos.each {|p| p.save!}
      verifying_integrity_for_deleted_photos
    end

    private

    attr_reader :hashtag

    def verifying_integrity_for_deleted_photos
      Photo.where.not(photo_id: @recent_proccesed_media).each{|photo|
        uri = URI(photo.url)
        Net::HTTP.start(uri.host, uri.port,
          :use_ssl => uri.scheme == 'https') do |http|
          res = http.request(Net::HTTP::Head.new(uri))
          photo.destroy if res.code != '200'
        end
      }
    end

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
        @recent_proccesed_media << media.id
        Photo.find_or_initialize_by(photo_id: media.id).tap do |photo|
          photo.attributes = {
            created_at: Time.at(media.created_time.to_i),
            link: media.link,
            message: media.try(:caption).try(:text),
            url: media.images.standard_resolution.url,
            user_handle: media.user.username,
            user_id: media.user.id,
            user_image_url: media.user.profile_picture.to_s,
            remote_profile_picture_url: media.user.profile_picture.to_s,
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
