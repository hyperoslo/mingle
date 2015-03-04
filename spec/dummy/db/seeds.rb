Mingle::Hashtag.create tag_name: "#hyper"

begin
  WebMock.allow_net_connect!

  # Fetch tweets from Twitter
  Mingle::Twitter.fetch

  # Fetch photos from Instagram
  #Mingle::Instagram.fetch
ensure
  WebMock.disable_net_connect!
end