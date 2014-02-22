# encoding: utf-8

require 'spec_helper'

describe Mingle::Facebook do

  let(:klhd_hashtag) { create :mingle_hashtag }
  let(:thousand_hashtag) { create :mingle_hashtag, tag_name: "#1000colours" }

  it 'should prefix the database table name of namespaced models' do
    expect(Mingle::Facebook.table_name_prefix).to eq 'mingle_facebook_'
  end

  before do
    stub_request(:get, /graph.facebook.com\/133713366690788\/posts/)
      .to_return body: fixture('mingle/facebook/page_posts.json')
    stub_request(:get, /graph.facebook.com\/search/)
      .to_return body: fixture('mingle/facebook/search_posts.json')
  end

  describe '#fetch' do
    it 'can fetch posts since the beginning of time' do
      Mingle::Facebook.should_receive(:posts_through_search).once
                   .with(klhd_hashtag, nil)
                   .and_call_original

      Mingle::Facebook.fetch klhd_hashtag
    end

    it 'accepts multiple hashtags' do
      Mingle::Facebook.should_receive(:posts_through_search).once
                   .with(klhd_hashtag, nil)
                   .and_call_original

      Mingle::Facebook.should_receive(:posts_through_search).once
                   .with(thousand_hashtag, nil)
                   .and_call_original

      Mingle::Facebook.fetch [klhd_hashtag, thousand_hashtag]
    end

    it 'can fetch posts since date/timestamp' do
      since = 2.weeks.ago

      Mingle::Facebook.should_receive(:posts_through_search).once
                   .with(klhd_hashtag, since)
                   .and_call_original

      Mingle::Facebook.fetch klhd_hashtag, since
    end

    it 'will create model instances for fetched posts' do
      posts = Mingle::Facebook.fetch klhd_hashtag

      post = posts.first

      expect(post.message).to eq '#KLHD'
      expect(post.type).to eq 'status'
      expect(post.user_id).to eq '577910407'
      expect(post.user_name).to eq 'John-John Myhrvold'
      expect(post.created_at).to eq DateTime.parse('2013-10-29T09:21:59+0000')

      post = posts.second

      expect(post.message).to eq '#klhd Rema skolen :D'
      expect(post.type).to eq 'status'
      expect(post.user_id).to eq '880440296'
      expect(post.user_name).to eq 'Chris-Stian Tjorven Selstad'
      expect(post.created_at).to eq DateTime.parse('2013-10-29T09:00:42+0000')

      expect(Mingle::Facebook::Post.count).to eq 2
    end

    it 'is idempotent' do
      Mingle::Facebook.fetch klhd_hashtag

      expect do
        Mingle::Facebook.fetch klhd_hashtag
      end.not_to change { Mingle::Facebook::Post.count }
    end
  end

  describe '#config' do
    it 'creates a new configuration if none exist' do
      Mingle::Facebook.config = nil
      expect(Mingle::Facebook.config).to be_a Mingle::Facebook::Configuration
    end

    it 'returns the existing configuration if it exists' do
      config = Mingle::Facebook::Configuration.new
      Mingle::Facebook.config = config
      expect(Mingle::Facebook.config).to eq config
    end
  end

  describe '#configure' do
    it 'sets the access token correctly' do
      Mingle::Facebook.config = nil
      Mingle::Facebook.configure do |config|
        config.access_token = 'LZRpP4jsLpx7Q8q5sF5z'
      end
    end
  end

end
