class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true
  has_many :user_comment_ratings, dependent: :destroy
  has_many :users, :through => :user_comment_ratings
end
