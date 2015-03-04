FactoryGirl.define do

  factory :mingle_twitter_tweet, class: Mingle::Twitter::Tweet do
    text 'Tweet content'
    tweet_id { rand(2 ** 32).to_s }
    user_handle 'timkurvers'
    user_name 'Tim Kurvers'
    user_id '84070520'
    remote_avatar_url 'http://a0.twimg.com/profile_images/1511444315/tim.oslo_normal.png'
  end

end
