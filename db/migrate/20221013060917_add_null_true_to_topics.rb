class AddNullTrueToTopics < ActiveRecord::Migration[7.0]
  def change
    change_column_null :topics, :title, false
    change_column_null :topics, :description, false
  end
end
