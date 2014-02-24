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
