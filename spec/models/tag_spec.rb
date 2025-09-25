require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'バリデーション' do
    it 'nameが空では登録できない' do
      tag = Tag.new(name: '')
      expect(tag).not_to be_valid
    end

    it 'nameが重複している場合は登録できない' do
      Tag.create!(name: '重複タグ')
      duplicate_tag = Tag.new(name: '重複タグ')
      expect(duplicate_tag).not_to be_valid
    end

    it 'nameが51文字以上では登録できない' do
      long_name = 'あ' * 51
      tag = Tag.new(name: long_name)
      expect(tag).not_to be_valid
    end

    it 'nameが50文字以下なら登録できる' do
      valid_name = 'あ' * 50
      tag = Tag.new(name: valid_name)
      expect(tag).to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'recipe_tagsを複数持てる' do
      expect(Tag.reflect_on_association(:recipe_tags).macro).to eq(:has_many)
    end

    it 'recipesを複数持てる' do
      expect(Tag.reflect_on_association(:recipes).macro).to eq(:has_many)
    end
  end

  describe 'スコープ' do
    describe '.popular' do
      it '関連レシピ数が多い順に並ぶ' do
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
      it '作成日時の新しい順に並ぶ' do
        tag1 = create(:tag, name: 'tag1', created_at: 1.day.ago)
        tag2 = create(:tag, name: 'tag2', created_at: Time.current)

        expect(Tag.recent).to eq([tag2, tag1])
      end
    end
  end

  describe '#recipe_count' do
    it '関連するレシピの数を返す' do
      tag = create(:tag)
      recipe1 = create(:recipe)
      recipe2 = create(:recipe)

      tag.recipes << [recipe1, recipe2]

      expect(tag.recipe_count).to eq(2)
    end
  end

  describe 'dependent: :destroy' do
    it 'tag削除時に関連するrecipe_tagsも削除される' do
      tag = create(:tag)
      recipe = create(:recipe)
      tag.recipes << recipe

      expect { tag.destroy }.to change { RecipeTag.count }.by(-1)
    end
  end
end
