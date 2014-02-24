namespace :mingle do

  desc "Fetch everything"
  task fetch: ['twitter:fetch', 'facebook:fetch', 'instagram:fetch']

  namespace :twitter do

    desc "Fetch tweets from Twitter"
    task fetch: :environment do
      Mingle::Twitter.fetch
    end

  end

  namespace :facebook do

    desc "Fetch posts from Facebook"
    task fetch: :environment do
      Mingle::Facebook.fetch
    end

  end

  namespace :instagram do

    desc "Fetch photos from Instagram"
    task fetch: :environment do
      Mingle::Instagram.fetch
    end

  end

end
