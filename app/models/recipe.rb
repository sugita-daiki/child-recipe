class Recipe < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_one_attached :image
  has_many :comments, dependent: :destroy
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  validates :title, presence: true
  validates :description, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :search, lambda { |keyword|
    where('title LIKE ? OR description LIKE ?', "%#{keyword}%", "%#{keyword}%")
  }
end
