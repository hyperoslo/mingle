module Mingle::Facebook

  class << self
    attr_writer :config

    def table_name_prefix
      "#{Mingle.table_name_prefix}facebook_"
    end

    # Fetch posts since given date/timestamp, last post's creation date or beginning of time
    def fetch(hashtags = Mingle::Hashtag.all, since = Mingle::Facebook::Post.ordered.last.try(:created_at))
      hashtags = Array(hashtags)

      posts = []
      hashtags.each do |hashtag|
        posts += posts_through_search hashtag, since
      end

      # Ole Robert Reitan's posts on his Facebook page
      posts += posts_by_page 133713366690788, since

      posts.collect do |data|
        create_post_from_data(data, hashtags)
      end
    end

    # Retrieves posts through given search query
    def posts_through_search hashtag, since
      posts = FbGraph::Post.search(hashtag.tag_name_with_hash, since: since.to_i, return_ssl_resources: 1, access_token: config.access_token)

      # Facebook search is fairly unpredictable, so ensure the query is actually mentioned
      posts.select { |post| matches? post, hashtag.tag_name }
    end

    # Retrieves posts for given page
    def posts_by_page page_id, since
      page = FbGraph::Page.new(page_id, access_token: config.access_token)
      page.posts(limit: 100, since: since.to_i, return_ssl_resources: 1)
    end

    def configure
      yield config
    end

    def config
      @config ||= Mingle::Facebook::Configuration.new
    end

    def create_post_from_data data, hashtags
      post = Post.find_or_initialize_by post_id: data.identifier

      post.attributes = {
        caption: data.caption,
        created_at: data.created_time,
        description: data.description,
        link: data.link,
        message: data.message,
        name: data.name,
        picture: data.picture,
        type: data.type,
        user_id: data.from.identifier,
        user_name: data.from.name
      }

      hashtags.each do |hashtag|
        if matches? post, hashtag.tag_name
          post.hashtags << hashtag unless post.hashtags.include? hashtag
        end
      end

      post.save!
      post
    end

    private

    def matches?(post, query)
      post.message.try(:match, /#{query}/i) ||
      post.description.try(:match, /#{query}/i) ||
      post.caption.try(:match, /#{query}/i)
    end

  end

end
