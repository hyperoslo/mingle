FactoryGirl.define do

  factory :mingle_facebook_post, class: Mingle::Facebook::Post do
    caption 'Caption'
    description 'Description'
    link 'http://hyper.no'
    message 'Post content'
    name 'Tim Kurvers'
    picture nil
    post_id { "#{rand(2 ** 32).to_s}_#{rand(2 ** 32).to_s}" }
    user_id 'timkurvers'
    user_name 'Tim Kurvers'
  end

end
