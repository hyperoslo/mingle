require 'webmock'

Mingle::Hashtag.create tag_name: "#hyper"

unless Rails.env.test?

  begin
    WebMock.allow_net_connect!

    Mingle::Twitter.fetch
    Mingle::Instagram.fetch
  ensure
    WebMock.disable_net_connect!
  end

end
