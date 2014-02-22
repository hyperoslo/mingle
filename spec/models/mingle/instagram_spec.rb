require 'spec_helper'

describe Mingle::Instagram do

  let(:hashtag) { create :mingle_hashtag, tag_name: 'klhd' }

  it 'should prefix the database table name of namespaced models' do
    expect(Mingle::Instagram.table_name_prefix).to eq 'mingle_instagram_'
  end

  it 'can fetch recent photos' do
    Instagram.should_receive(:tag_recent_media).once
             .with('klhd').and_return []

    Mingle::Instagram.fetch hashtag
  end

  it 'will create model instances for fetched photos' do
    stub_request(:get, /api\.instagram\.com\/v1\/tags\/klhd\/media\/recent\.json/).to_return body: fixture('mingle/instagram/photos.json')

    photos = Mingle::Instagram.fetch hashtag

    photo = photos.first

    expect(photo.created_at).to eq Time.at(1369985275)
    expect(photo.link).to eq 'https://instagram.com/p/Z97x-zEBXL/'
    expect(photo.photo_id).to eq '467792855743600075_272366028'
    expect(photo.message).to eq 'foo'
    expect(photo.url).to eq 'https://distilleryimage7.s3.amazonaws.com/9c90802cc9c311e2868a22000a9f18a6_7.jpg'
    expect(photo.user_handle).to eq 'eivindhilling'
    expect(photo.user_id).to eq '272366028'
    expect(photo.user_image_url).to eq 'https://distillery.s3.amazonaws.com/profiles/profile_272366028_75sq_1365676035.jpg'

    photo = photos.last

    expect(photo.created_at).to eq Time.at(1366202692)
    expect(photo.link).to eq 'https://instagram.com/p/YNNE4ckBfI/'
    expect(photo.photo_id).to eq '436062249016104904_272366028'
    expect(photo.message).to eq nil
    expect(photo.url).to eq 'https://distilleryimage4.s3.amazonaws.com/995b39c6a75c11e2918122000a9f4d8a_7.jpg'
    expect(photo.user_handle).to eq 'eivindhilling'
    expect(photo.user_id).to eq '272366028'
    expect(photo.user_image_url).to eq 'https://distillery.s3.amazonaws.com/profiles/profile_272366028_75sq_1365676035.jpg'

    expect(Mingle::Instagram::Photo.count).to be 2
  end

  it 'associates hashtags to photos' do
    stub_request(:get, /api\.instagram\.com\/v1\/tags\/klhd\/media\/recent\.json/).to_return body: fixture('mingle/instagram/photos.json')

    photos = Mingle::Instagram.fetch hashtag

    photo = photos.first

    expect(photo.hashtags).to eq [ hashtag ]
  end

end
