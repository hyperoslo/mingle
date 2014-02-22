FactoryGirl.define do

  factory :mingle_feed_item, class: Mingle::Feed::Item do
    feedable nil
    created_at { Time.now }
    published true
  end

end
