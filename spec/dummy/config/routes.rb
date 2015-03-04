Rails.application.routes.draw do

  get 'tweets/index'

  mount Mingle::Engine => "/mingle"
end
