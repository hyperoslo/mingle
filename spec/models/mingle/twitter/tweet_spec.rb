require 'spec_helper'

describe Mingle::Twitter::Tweet do
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
end
