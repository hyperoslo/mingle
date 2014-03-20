# Mingle

[![Code Climate](https://codeclimate.com/github/hyperoslo/mingle.png)](https://codeclimate.com/github/hyperoslo/mingle)
[![Build Status](https://travis-ci.org/hyperoslo/mingle.png)](https://travis-ci.org/hyperoslo/mingle)

Mingle makes it really easy to syndicate posts from Facebook, tweets from Twitter and photos from Instagram
in your Ruby on Rails application.

## Installation

Add this line to your application's Gemfile:

    gem 'mingle'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mingle

Install the migrations:

    rake mingle:install:migrations
    
Run the migrations:

    rake db:migrate

## Usage

```ruby
# Create some hashtags to syndicate content from
Mingle::Hashtag.create tag_name: "#hyper"

# Fetch posts from Facebook
Mingle::Facebook.fetch

# Fetch tweets from Twitter
Mingle::Twitter.fetch

# Fetch photos from Instagram
Mingle::Instagram.fetch
```

Mingle also ships with rake tasks:

```bash
$ rake mingle:facebook:fetch
$ rake mingle:twitter:fetch
$ rake mingle:instagram:fetch
```

## Jobs

Mingle ships with Sidekiq jobs for your perusal.

## Configuration

Mingle is configured through `Mingle.configure`, like this:

```ruby
Mingle.configure do |config|
  config.facebook_access_token = ENV['FACEBOOK_ACCESS_TOKEN']
  # ...
end
```

You can also configure it temporarily:

```ruby
Mingle.temporarily facebook_access_token: 'ABC123' do
  # ...
end
```

The following configurations can be made through `Mingle.configure`:

* `facebook_access_token` - A Facebook application's access token.
* `twitter_api_key` - A Twitter application's API key.
* `twitter_api_secret` - A Twitter application's API secret.
* `twitter_access_token` - A Twitter application's access token.
* `twitter_access_token_secret` - A Twitter application's access token secret.
* `instagram_client_id` - An Instagram application's client id.

**Note:** We recommend you store your application configuration in your
environment, like in the example above. In fact, we recommend it so much that
Mingle will automatically look for environment variables with specific names,
unless you configure them through `Mingle.configure`.

Mingle checks for following environment variables by default:

* `FACEBOOK_ACCESS_TOKEN` - the equivalent of `facebook_access_token`
* `TWITTER_API_KEY` - the equivalent of `twitter_api_key`
* `TWITTER_API_SECRET` - the equivalent of `twitter_api_secret`
* `TWITTER_ACCESS_TOKEN` - the equivalent of `twitter_access_token`
* `TWITTER_ACCESS_TOKEN_SECRET` - the equivalent of `twitter_access_token_secret`
* `INSTAGRAM_CLIENT_ID` - the equivalent of `instagram_client_id`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Hyper made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.


## License

Mingle is available under the MIT license. See the LICENSE file for more info.
