class InstagramPhotosController < ApplicationController
  def index
    @photos = Mingle::Instagram::Photo.all
  end
end
