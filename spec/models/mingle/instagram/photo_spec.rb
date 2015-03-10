require 'spec_helper'

describe Mingle::Instagram::Photo do
  describe "#author" do
    it 'should be the user handle' do
      expect(subject.author).to eq subject.user_handle
    end
  end

  describe "#avatar" do
    it 'should be the user image url' do
      expect(subject.avatar).to eq subject.user_image_url
    end
  end

  describe "#message" do
    it 'should be the same as text' do
      expect(subject.message).to eq subject.text
    end
  end

  describe "#created_before?" do
    it 'should return true' do
      photo = described_class.new(created_at: 1.day.ago)
      expect(photo.created_before?(Date.current)).to eq(true)
    end

    it 'should return false' do
      photo = described_class.new(created_at: 1.day.ago)
      expect(photo.created_before?(2.day.ago)).to eq(false)
    end

    it 'should return false when date is nil' do
      photo = described_class.new(created_at: 1.day.ago)
      expect(photo.created_before?(nil)).to eq(false)
    end
  end

  describe "#rejected_user?" do
    it "should return true" do
      photo = described_class.new(user_handle: 'rejected_user')
      expect(photo.rejected_user?(['rejected_user'])).to eq(true)
    end
    it "should return false" do
      photo = described_class.new(user_handle: 'not_rejected_user')
      expect(photo.rejected_user?(['rejected_user'])).to eq(false)
    end
  end

  describe '#include_rejected_word?' do
    it "should return true" do
      photo = described_class.new(message: 'rejectedWord')
      expect(photo.include_rejected_word?(['rejectedword'])).to eq(true)
    end

    it "should return false rejected_words is empty array" do
      photo = described_class.new(message: 'rejectedWord')
      expect(photo.include_rejected_word?([])).to eq(false)
    end

    it "should return false when given empty strings and nil" do
      photo = described_class.new(message: 'rejectedWord')
      expect(photo.include_rejected_word?(['', nil])).to eq(false)
    end

    it 'should return false when message is nil' do
      photo = described_class.new(message: nil)
      expect(photo.include_rejected_word?(['rejectedword'])).to eq(false)
    end

    it "should return false" do
      photo = described_class.new(message: 'notRejectedWord')
      expect(photo.include_rejected_word?(['rejectedword'])).to eq(false)
    end

  end
end
