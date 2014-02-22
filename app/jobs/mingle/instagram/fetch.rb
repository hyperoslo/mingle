class Mingle::Instagram::Fetch
  include Sidekiq::Worker

  sidekiq_options queue: :mingle, retry: false

  def perform
    Mingle::Instagram.fetch
  end

end
