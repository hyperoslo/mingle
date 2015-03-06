FactoryGirl.define do

  factory :mingle_instagram_photo, class: Mingle::Instagram::Photo do
    photo_id 1
    url 'http://instagram.com/photo.jpg'
    link 'http://instagram.com/link/to/photo'
    user_id 1
    user_handle 'timkurvers'
    user_image_url 'http://instagram.com/profile/image/url.jpg'
    remote_profile_picture_url 'http://instagram.com/profile/image/url.jpg'
  end

end
