# Mingle

[![Code Climate](https://codeclimate.com/github/hyperoslo/mingle.png)](https://codeclimate.com/github/hyperoslo/mingle)

Facebook, Twitter and Instagram integration for Ruby on Rails

## Installation

Add this line to your application's Gemfile:

    gem 'mingle'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mingle

## Usage

```ruby
# Fetch posts from Facebook
Mingle::Facebook.fetch

# Fetch tweets from Twitter
Mingle::Twitter.fetch

# Fetch photos from Instagram
Mingle::Instagram.fetch
```

## Configuration

Mingle looks to the following environment variables for its configuration:

* `FACEBOOK_ACCESS_TOKEN` - A Facebook application's access token.
* `TWITTER_API_KEY` - A Twitter application's API key.
* `TWITTER_API_SECRET` - A Twitter application's API secret.
* `TWITTER_ACCESS_TOKEN` - A Twitter application's access token.
* `TWITTER_ACCESS_TOKEN_SECRET` - A Twitter application's access token secret.
* `INSTAGRAM_CLIENT_ID` - An Instagram application's client id.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Hyper made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.
