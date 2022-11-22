class Rating < ApplicationRecord
  belongs_to :post
  after_create :avg_rate

  private
  def avg_rate
    rate = Rating.where(post_id: post.id).average(:rate)
    Post.where(id: post.id).update(:average_rating => rate)
  end
end
