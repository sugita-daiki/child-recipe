class Recipe < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1000 }

  scope :recent, -> { order(created_at: :desc) }
  scope :search, lambda { |keyword|
    where('title LIKE ? OR description LIKE ?', "%#{keyword}%", "%#{keyword}%")
  }
  scope :by_tag, lambda { |tag_name|
    joins(:tags).where(tags: { name: tag_name })
  }
end
