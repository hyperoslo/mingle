require 'spec_helper'

describe Mingle::Facebook::Post do

  describe '#large_picture' do
    it 'provides its picture in large format' do
      subject.picture = 'https://facebook.com/images/_s/123871_s.jpg'
      expect(subject.large_picture).to eq('https://facebook.com/images/_s/123871_b.jpg')

      subject.picture = 'https://facebook.com/images/_s/123871_s.jpeg'
      expect(subject.large_picture).to eq('https://facebook.com/images/_s/123871_b.jpeg')

      subject.picture = 'https://facebook.com/images/_s/123871_s.png'
      expect(subject.large_picture).to eq('https://facebook.com/images/_s/123871_b.png')

      subject.picture = 'https://facebook.com/images/_s/123871_s.gif'
      expect(subject.large_picture).to eq('https://facebook.com/images/_s/123871_b.gif')

      subject.picture = nil
      expect(subject.large_picture).to be_nil
    end
  end

  describe '#profile_url' do
    it 'provides Facebook profile link' do
      subject.user_id = 'timkurvers'
      expect(subject.profile_url).to eq 'https://www.facebook.com/timkurvers'

      subject.user_id = nil
      expect(subject.profile_url).to be_nil
    end
  end

  describe '#profile_image_url' do
    it 'provides profile image through Graph API' do
      subject.user_id = 'timkurvers'
      expect(subject.profile_image_url).to eq 'https://graph.facebook.com/timkurvers/picture'

      subject.user_id = nil
      expect(subject.profile_image_url).to be_nil
    end
  end

  describe "#author" do
    it 'should be the username' do
      expect(subject.author).to eq subject.user_name
    end
  end

  describe "#avatar" do
    it 'should be the profile image' do
      expect(subject.avatar).to eq subject.profile_image_url
    end
  end
end
