require 'spec_helper'

describe Mingle::Instagram do

  let(:hashtag) { create :mingle_hashtag, tag_name: 'klhd' }

  it 'should prefix the database table name of namespaced models' do
    expect(Mingle::Instagram.table_name_prefix).to eq 'mingle_instagram_'
  end

  it 'fetch photos for hashtag' do
    photos_fetcher = instance_spy(Mingle::Instagram::PhotosFetcher)
    expect(Mingle::Instagram::PhotosFetcher).to receive(:new).with(hashtag).and_return(photos_fetcher)

    Mingle::Instagram.fetch hashtag

    expect(photos_fetcher).to have_received(:fetch)
  end

end
