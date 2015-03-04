Rails.application.routes.draw do

  get 'instagram_photos/index'

  get 'tweets/index'

  mount Mingle::Engine => "/mingle"
end
