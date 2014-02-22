require 'spec_helper'

describe Mingle::Hashtag do

  describe '#tag_name_with_hash' do
    context 'when the tag name already is prepended with a hash' do
      subject { build_stubbed :mingle_hashtag, tag_name: '#klhd' }

      it 'returns the tag name' do
        expect(subject.tag_name_with_hash).to eq "#klhd"
      end
    end

    context 'when the tag name is not prepended with a hash' do
      subject { build_stubbed :mingle_hashtag, tag_name: 'klhd' }

      it 'returns the tag name prepepded with a hash' do
        expect(subject.tag_name_with_hash).to eq "#klhd"
      end
    end
  end

  describe '#tag_name_without_hash' do
    context 'when the tag name already is prepended with a hash' do
      subject { build_stubbed :mingle_hashtag, tag_name: '#klhd' }

      it 'returns the tag name without the prefixed hash' do
        expect(subject.tag_name_without_hash).to eq "klhd"
      end
    end

    context 'when the tag name is not prepended with a hash' do
      subject { build_stubbed :mingle_hashtag, tag_name: 'klhd' }

      it 'returns the tag name' do
        expect(subject.tag_name_without_hash).to eq "klhd"
      end
    end
  end

end
