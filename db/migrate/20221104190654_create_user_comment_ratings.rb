class CreateUserCommentRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :user_comment_ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.integer :rate

      t.timestamps
    end
  end
end
