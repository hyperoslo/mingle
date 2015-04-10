namespace :mingle do

  desc "Fetch everything"
  task fetch: ['twitter:fetch', 'facebook:fetch', 'instagram:fetch']
  task clear: ['twitter:clear', 'facebook:clear', 'instagram:clear']

  namespace :twitter do

    desc "Fetch tweets from Twitter"
    task fetch: :environment do
      Mingle::Twitter.fetch
    end

    desc "Clear tweets from Twitter"
    task clear: :environment do
      Mingle::Twitter::Tweet.destroy_all
    end

  end

  namespace :facebook do

    desc "Fetch posts from Facebook"
    task fetch: :environment do
      Mingle::Facebook.fetch
    end

    desc "Clear posts from Facebook"
    task clear: :environment do
      Mingle::Facebook::Post.destroy_all
    end

  end

  namespace :instagram do

    desc "Fetch photos from Instagram"
    task fetch: :environment do
      Mingle::Instagram.fetch
    end

    desc "Clear photos from Instagram"
    task clear: :environment do
      Mingle::Instagram::Photo.destroy_all
    end

    desc "Clean up Instagram removed photos"
    task prune: :environment do
      Mingle::Instagram.prune
    end

  end

end
