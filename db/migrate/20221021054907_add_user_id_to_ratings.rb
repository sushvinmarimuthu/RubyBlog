class AddUserIdToRatings < ActiveRecord::Migration[7.0]
  def change
    add_reference :ratings, :user, index: true
  end
end
