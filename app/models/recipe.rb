class Recipe < ApplicationRecord
  belongs_to :user
  has_many :likes
  has_one_attached :image
  has_many :comments
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  validates :title, presence: true
  validates :description, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
