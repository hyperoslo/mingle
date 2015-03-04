require 'webmock'

Mingle::Hashtag.create tag_name: "#hyper"

unless Rails.env.test?

  begin
    WebMock.allow_net_connect!

    # Fetch tweets from Twitter
    Mingle::Twitter.fetch

    # Fetch photos from Instagram
    #Mingle::Instagram.fetch
  ensure
    WebMock.disable_net_connect!
  end

end