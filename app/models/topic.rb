class Topic < ApplicationRecord
  validates :title, presence: true, length: { maximum: 20 }
  has_many :posts, dependent: :destroy
end
