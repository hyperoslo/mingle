class TweetsController < ApplicationController
  def index
    @tweets = Mingle::Twitter::Tweet.all
  end
end
