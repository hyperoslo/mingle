class Mingle::Hashtagging < ActiveRecord::Base
  belongs_to :hashtaggable, polymorphic: true
  belongs_to :hashtag
end
