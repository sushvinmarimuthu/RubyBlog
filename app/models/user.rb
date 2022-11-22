class User < ApplicationRecord
  # after_create :send_welcome_email
  has_many :posts, dependent: :destroy
  has_many :user_comment_ratings, dependent: :destroy
  has_many :comments, :through => :user_comment_ratings, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_and_belongs_to_many :users_posts, join_table: 'users_posts',  :class_name => 'Post'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create do
    UserJob.perform_now(self)
  end
end
