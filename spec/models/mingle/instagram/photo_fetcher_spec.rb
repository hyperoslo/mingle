require 'spec_helper'

describe Mingle::Instagram::PhotoFetcher do
  let(:hashtag) { create :mingle_hashtag, tag_name: 'klhd' }
  subject(:photo_fetcher) { described_class.new(hashtag) }

  it 'can fetch recent photos' do
    expect(Instagram).to receive(:tag_recent_media).once
             .with('klhd').and_return []

    photo_fetcher.fetch
  end

  describe 'build photos' do
    before do
      stub_request(:get, /api\.instagram\.com\/v1\/tags\/klhd\/media\/recent\.json/).to_return body: fixture('mingle/instagram/photos.json')
    end

    let(:photos) { photo_fetcher.fetch }

    it 'will create model instances for fetched photos' do
      photo = photos.first

      expect(photo.created_at).to eq Time.at(1369985275)
      expect(photo.link).to eq 'http://instagram.com/p/Z97x-zEBXL/'
      expect(photo.photo_id).to eq '467792855743600075_272366028'
      expect(photo.message).to eq 'foo'
      expect(photo.url).to eq 'http://distilleryimage7.s3.amazonaws.com/9c90802cc9c311e2868a22000a9f18a6_7.jpg'
      expect(photo.user_handle).to eq 'eivindhilling'
      expect(photo.user_id).to eq '272366028'
      expect(photo.user_image_url).to eq 'http://images.ak.instagram.com/profiles/profile_272366028_75sq_1365676035.jpg'
      expect(photo.user_name).to eq 'Eivind Hilling'

      photo = photos.last

      expect(photo.created_at).to eq Time.at(1366202692)
      expect(photo.link).to eq 'http://instagram.com/p/YNNE4ckBfI/'
      expect(photo.photo_id).to eq '436062249016104904_272366028'
      expect(photo.message).to eq nil
      expect(photo.url).to eq 'http://distilleryimage4.s3.amazonaws.com/995b39c6a75c11e2918122000a9f4d8a_7.jpg'
      expect(photo.user_handle).to eq 'eivindhilling'
      expect(photo.user_id).to eq '272366028'
      expect(photo.user_image_url).to eq 'http://images.ak.instagram.com/profiles/profile_272366028_75sq_1365676035.jpg'
      expect(photo.user_name).to eq 'Eivind Hilling'

      expect(Mingle::Instagram::Photo.count).to be 2
    end

    it 'associates hashtags to photos' do
      photo = photos.first

      expect(photo.hashtags).to eq [ hashtag ]
    end
  end

  describe 'ignoring tweets' do
    it 'should ignore tweets created before since configuration' do
      photo_created_before = double('photo created before', 
                                    created_before?: true, 
                                    include_rejected_word?: false,
                                    rejected_user?: false)
      photo_created_after = double('photo created after',
                                    created_before?: false,
                                    include_rejected_word?: false,
                                    rejected_user?: false,
                                    save!: true)
      allow(photo_fetcher).to receive(:photos_for_hashtag).
        and_return([photo_created_after, photo_created_before])
      expect(photo_fetcher.fetch.count).to eq(1)
    end

    it 'should ignore tweets which include rejected words' do
      photo_with_rejected_word = double('photo with rejected word', 
                                    created_before?: false, 
                                    include_rejected_word?: true,
                                    rejected_user?: false)
      photo_without_rejected_word = double('photo without rejected word',
                                    created_before?: false,
                                    include_rejected_word?: false,
                                    rejected_user?: false,
                                    save!: true)
      allow(photo_fetcher).to receive(:photos_for_hashtag).
        and_return([photo_with_rejected_word, photo_without_rejected_word])
      expect(photo_fetcher.fetch.count).to eq(1)
    end

    it 'should ignore tweets which include rejected user' do
      photo_with_rejected_user = double('photo with rejected user', 
                                    created_before?: false, 
                                    include_rejected_word?: false,
                                    rejected_user?: true)
      photo_without_rejected_user = double('photo without rejected user',
                                    created_before?: false,
                                    include_rejected_word?: false,
                                    rejected_user?: false,
                                    save!: true)
      allow(photo_fetcher).to receive(:photos_for_hashtag).
        and_return([photo_with_rejected_user, photo_without_rejected_user])
      expect(photo_fetcher.fetch.count).to eq(1)
    end
  end
end
