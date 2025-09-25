require 'rails_helper'

RSpec.describe RecipeTag, type: :model do
  describe 'バリデーション' do
    let(:recipe) { create(:recipe) }
    let(:tag) { create(:tag) }

    it 'recipeとtagがあれば有効' do
      recipe_tag = build(:recipe_tag, recipe: recipe, tag: tag)
      expect(recipe_tag).to be_valid
    end

    it 'recipe_idが空では無効' do
      recipe_tag = build(:recipe_tag, recipe: nil, tag: tag)
      expect(recipe_tag).not_to be_valid
      expect(recipe_tag.errors[:recipe_id]).to include("can't be blank")
    end

    it 'tag_idが空では無効' do
      recipe_tag = build(:recipe_tag, recipe: recipe, tag: nil)
      expect(recipe_tag).not_to be_valid
      expect(recipe_tag.errors[:tag_id]).to include("can't be blank")
    end

    it 'recipe_idとtag_idの組み合わせが重複している場合は無効' do
      create(:recipe_tag, recipe: recipe, tag: tag)
      duplicate = build(:recipe_tag, recipe: recipe, tag: tag)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:recipe_id]).to include('このレシピには既に同じタグが設定されています')
    end
  end

  describe 'アソシエーション' do
    it 'recipeに属している' do
      assoc = described_class.reflect_on_association(:recipe)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it 'tagに属している' do
      assoc = described_class.reflect_on_association(:tag)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end
end
