FactoryGirl.define do

  factory :mingle_hashtaggings, class: 'Mingle::Hashtagging' do
    association :hashtaggable, factory: :mingle_facebook_post
    association :hashtag, factory: :mingle_hashtag
  end

end
