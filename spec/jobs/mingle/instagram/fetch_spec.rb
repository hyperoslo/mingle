require 'spec_helper'

describe Mingle::Instagram::Fetch do
  it 'will invoke fetch' do
    Mingle::Instagram.should_receive(:fetch)

    subject.perform
  end
end
