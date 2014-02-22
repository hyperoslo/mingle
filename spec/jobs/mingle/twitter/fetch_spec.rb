require 'spec_helper'

describe Mingle::Twitter::Fetch do
  it 'will invoke fetch' do
    Mingle::Twitter.should_receive(:fetch)

    subject.perform
  end
end
