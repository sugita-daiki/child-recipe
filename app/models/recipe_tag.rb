class RecipeTag < ApplicationRecord
  belongs_to :recipe
  belongs_to :tag

  validates :recipe_id, uniqueness: { scope: :tag_id, message: 'このレシピには既に同じタグが設定されています' }
  validates :recipe_id, presence: true
  validates :tag_id, presence: true
end
