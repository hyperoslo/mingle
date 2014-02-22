class Mingle::Facebook::Fetch
  include Sidekiq::Worker

  sidekiq_options queue: :mingle, retry: false

  def perform
    Mingle::Facebook.fetch
  end
end
