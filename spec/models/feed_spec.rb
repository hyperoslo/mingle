require 'spec_helper'

describe Mingle::Feed do

  it 'should prefix the database table name of namespaced models' do
    expect(described_class.table_name_prefix).to eq 'mingle_feed_'
  end

end
