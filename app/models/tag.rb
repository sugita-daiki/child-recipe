class Tag < ApplicationRecord
  has_many :recipe_tags, dependent: :destroy
  has_many :recipes, through: :recipe_tags

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }

  scope :popular, -> { joins(:recipes).group('tags.id').order('COUNT(recipes.id) DESC') }
  scope :recent, -> { order(created_at: :desc) }

  def recipe_count
    recipes.count
  end
end
