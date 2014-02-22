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

      Mingle::Facebook.should_receive(:posts_by_page).once
                   .with(133713366690788, nil)
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

      Mingle::Facebook.should_receive(:posts_by_page).once
                   .with(133713366690788, nil)
                   .and_call_original

      Mingle::Facebook.fetch [klhd_hashtag, thousand_hashtag]
    end

    it 'can fetch posts since date/timestamp' do
      since = 2.weeks.ago

      Mingle::Facebook.should_receive(:posts_through_search).once
                   .with(klhd_hashtag, since)
                   .and_call_original

      Mingle::Facebook.should_receive(:posts_by_page).once
                   .with(133713366690788, since)
                   .and_call_original

      Mingle::Facebook.fetch klhd_hashtag, since
    end

    it 'will create model instances for fetched posts' do
      posts = Mingle::Facebook.fetch klhd_hashtag

      post = posts.first

      expect(post.created_at).to eq DateTime.parse('2013-10-29T09:21:59+0000')
      expect(post.message).to eq '#KLHD'
      expect(post.type).to eq 'status'
      expect(post.user_id).to eq '577910407'
      expect(post.user_name).to eq 'John-John Myhrvold'

      post = posts.second

      expect(post.created_at).to eq DateTime.parse('2013-10-29T09:00:42+0000')
      expect(post.message).to eq '#klhd Rema skolen :D'
      expect(post.type).to eq 'status'
      expect(post.user_id).to eq '880440296'
      expect(post.user_name).to eq 'Chris-Stian Tjorven Selstad'

      post = posts.third

      expect(post.caption).to be_nil
      expect(post.created_at).to eq DateTime.parse('2013-05-29T08:01:00+0000')
      expect(post.description).to be_nil
      expect(post.link).to eq 'https://www.facebook.com/photo.php?fbid=541643485897772&set=a.133719816690143.26618.133713366690788&type=1&relevant_count=1'
      expect(post.message).to match /^Denne uken sitter nye REMA 1000-kjøpmenn i Gladengveien/
      expect(post.name).to be_nil
      expect(post.picture).to eq 'http://photos-e.ak.fbcdn.net/hphotos-ak-frc3/312138_541643485897772_481929988_s.jpg'
      expect(post.type).to eq 'photo'
      expect(post.user_id).to eq '133713366690788'
      expect(post.user_name).to eq 'Ole Robert Reitan, REMA 1000'

      post = posts.fourth

      expect(post.caption).to eq 'www.side2.no'
      expect(post.created_at).to eq DateTime.parse('2013-05-28T09:03:53+0000')
      expect(post.description).to be_nil
      expect(post.link).to eq 'http://www.side2.no/livsstil/article3628296.ece'
      expect(post.message).to eq '10 av 10 pristester vunnet hittil i år.'
      expect(post.name).to eq 'Her er frukt og grønt billigst'
      expect(post.picture).to eq 'http://external.ak.fbcdn.net/safe_image.php?d=AQDFGTVlfnpIRdi9&w=154&h=154&url=http%3A%2F%2Fwww.nettavisen.no%2Fmultimedia%2Fna%2Farchive%2F01210%2FHandlekurv_matv_121052116x9.jpg'
      expect(post.type).to eq 'link'
      expect(post.user_id).to eq '133713366690788'
      expect(post.user_name).to eq 'Ole Robert Reitan, REMA 1000'

      post = posts.last

      expect(post.caption).to eq 'www.mynewsdesk.com'
      expect(post.created_at).to eq DateTime.parse('2013-04-06T08:33:19+0000')
      expect(post.description).to match /^Gjennom sponsoravtalen med REMA 1000 starter Streetfootball Norway i dag/
      expect(post.link).to eq 'http://www.mynewsdesk.com/no/pressroom/reitangruppen/pressrelease/view/i-dag-starter-streetfootball-academy-853087?utm_source=realtime&utm_medium=email&utm_campaign=Subscription&utm_content'
      expect(post.message).to match /^Streetfootball Academy 2013 er nå i gang./
      expect(post.name).to eq 'I dag starter Streetfootball Academy'
      expect(post.picture).to eq 'http://external.ak.fbcdn.net/safe_image.php?d=AQD0kmjJlgYHPjCU&w=154&h=154&url=http%3A%2F%2Fa1.mndcdn.com%2Fimage%2Fupload%2Ft_article_v2%2Fvyocdkw3iyxoxvmnzwin.jpg'
      expect(post.type).to eq 'link'
      expect(post.user_id).to eq '133713366690788'
      expect(post.user_name).to eq 'Ole Robert Reitan, REMA 1000'

      expect(Mingle::Facebook::Post.count).to eq 5
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
