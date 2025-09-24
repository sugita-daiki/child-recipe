require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:recipe_tags).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:recipe_tags) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(100) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_most(1000) }
  end

  describe 'scopes' do
    describe '.recent' do
      it 'orders recipes by created_at desc' do
        recipe1 = create(:recipe)
        recipe2 = create(:recipe)

        expect(Recipe.recent).to eq([recipe2, recipe1])
      end
    end

    describe '.search' do
      let!(:recipe1) { create(:recipe, title: 'クッキーレシピ', description: '甘いクッキー') }
      let!(:recipe2) { create(:recipe, title: 'ケーキレシピ', description: '美味しいケーキ') }

      it 'finds recipes by title' do
        results = Recipe.search('クッキー')
        expect(results).to include(recipe1)
        expect(results).not_to include(recipe2)
      end

      it 'finds recipes by description' do
        results = Recipe.search('甘い')
        expect(results).to include(recipe1)
        expect(results).not_to include(recipe2)
      end
    end

    describe '.by_tag' do
      let!(:recipe1) { create(:recipe) }
      let!(:recipe2) { create(:recipe) }
      let!(:tag) { create(:tag, name: 'クッキー') }

      before do
        recipe1.tags << tag
      end

      it 'finds recipes by tag name' do
        results = Recipe.by_tag('クッキー')
        expect(results).to include(recipe1)
        expect(results).not_to include(recipe2)
      end
    end
  end

  describe '#liked_by?' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe) }

    context 'when user has liked the recipe' do
      before { create(:like, user: user, recipe: recipe) }

      it 'returns true' do
        expect(recipe.liked_by?(user)).to be true
      end
    end

    context 'when user has not liked the recipe' do
      it 'returns false' do
        expect(recipe.liked_by?(user)).to be false
      end
    end
  end

  describe 'image attachment' do
    let(:recipe) { build(:recipe) }

    it 'can have an attached image' do
      expect(recipe.image).to be_attached.or be_nil
    end
  end

  describe 'dependent destroy' do
    let(:recipe) { create(:recipe) }

    it 'destroys associated likes when recipe is destroyed' do
      create(:like, recipe: recipe)
      expect { recipe.destroy }.to change { Like.count }.by(-1)
    end

    it 'destroys associated comments when recipe is destroyed' do
      create(:comment, recipe: recipe)
      expect { recipe.destroy }.to change { Comment.count }.by(-1)
    end

    it 'destroys associated recipe_tags when recipe is destroyed' do
      tag = create(:tag)
      recipe.tags << tag
      expect { recipe.destroy }.to change { RecipeTag.count }.by(-1)
    end
  end
end
