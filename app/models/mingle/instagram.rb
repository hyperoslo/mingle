module Mingle::Instagram

  def self.table_name_prefix
    "#{Mingle.table_name_prefix}instagram_"
  end

  def self.fetch hashtags = Mingle::Hashtag.all
    hashtags = Array(hashtags)

    hashtags.flat_map do |hashtag|
      PhotoFetcher.new(hashtag).fetch
    end
  end
end
