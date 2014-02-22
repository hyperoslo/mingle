require 'spec_helper'

describe Mingle::Facebook::Fetch do
  it 'will invoke fetch' do
    Mingle::Facebook.should_receive(:fetch)

    subject.perform
  end
end
