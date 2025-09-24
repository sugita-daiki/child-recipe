require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:recipe_tags).dependent(:destroy) }
    it { is_expected.to have_many(:recipes).through(:recipe_tags) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
  end

  describe 'scopes' do
    describe '.popular' do
      it 'orders tags by recipe count' do
        tag1 = create(:tag, name: 'tag1')
        tag2 = create(:tag, name: 'tag2')
        recipe1 = create(:recipe)
        recipe2 = create(:recipe)

        tag1.recipes << recipe1
        tag2.recipes << [recipe1, recipe2]

        expect(Tag.popular).to eq([tag2, tag1])
      end
    end

    describe '.recent' do
      it 'orders tags by created_at desc' do
        tag1 = create(:tag, name: 'tag1')
        tag2 = create(:tag, name: 'tag2')

        expect(Tag.recent).to eq([tag2, tag1])
      end
    end
  end

  describe '#recipe_count' do
    it 'returns the count of associated recipes' do
      tag = create(:tag)
      recipe1 = create(:recipe)
      recipe2 = create(:recipe)

      tag.recipes << [recipe1, recipe2]

      expect(tag.recipe_count).to eq(2)
    end
  end

  describe 'dependent destroy' do
    let(:tag) { create(:tag) }

    it 'destroys associated recipe_tags when tag is destroyed' do
      recipe = create(:recipe)
      tag.recipes << recipe

      expect { tag.destroy }.to change { RecipeTag.count }.by(-1)
    end
  end
end
