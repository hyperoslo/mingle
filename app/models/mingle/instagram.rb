module Mingle::Instagram

  def self.table_name_prefix
    "#{Mingle.table_name_prefix}instagram_"
  end

  def self.fetch hashtags = Mingle::Hashtag.all
    hashtags = Array(hashtags)

    hashtags.flat_map do |hashtag|
      PhotosFetcher.new(hashtag).fetch
    end
  end

  def self.prune
    Mingle::Instagram::Photo.all.each{|photo|
      uri = URI(photo.url)
      Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        res = http.request(Net::HTTP::Head.new(uri))
        photo.destroy if res.code != '200'
      end
    }
  end
end
