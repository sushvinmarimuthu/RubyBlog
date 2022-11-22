class AddAvgRatingToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :average_rating, :float
  end
end
