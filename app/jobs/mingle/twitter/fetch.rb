class Mingle::Twitter::Fetch
  include Sidekiq::Worker

  sidekiq_options queue: :mingle, retry: false

  def perform
    Mingle::Twitter.fetch
  end

end
