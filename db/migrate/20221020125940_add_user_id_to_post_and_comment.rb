class AddUserIdToPostAndComment < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :user, index: true
    add_reference :comments, :user, index: true
  end
end
