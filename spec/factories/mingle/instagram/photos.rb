FactoryGirl.define do

  factory :mingle_instagram_photo, class: Mingle::Instagram::Photo do
    photo_id 1
    url 'http://instagram.com/photo.jpg'
    link 'http://instagram.com/link/to/photo'
    user_id 1
    user_handle 'timkurvers'
    remote_avatar_url 'http://instagram.com/profile/image/url.jpg'
  end

end
