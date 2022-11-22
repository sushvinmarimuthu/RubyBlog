class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 20 }
  belongs_to :topic
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :posts_tags, dependent: :destroy
  has_many :tags, through: :posts_tags
  has_many :ratings, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  has_and_belongs_to_many :users_posts, join_table: 'users_posts', :class_name => 'User'

  scope :with_from_to, ->(from_date, to_date) { where("DATE(posts.created_at) >= ? AND DATE(posts.created_at) <= ?", from_date, to_date) }

  def self.tagged_with(name)
    Tag.find_by!(name: name).posts
  end
  def all_tags=(names)
    self.tags = names.split(',').map do |name|
      Tag.where(name: name.strip.downcase.capitalize).first_or_create!
    end
  end
  def all_tags
    tags.map(&:name).join(",")
  end
end
