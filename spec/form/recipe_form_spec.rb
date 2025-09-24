require 'rails_helper'

RSpec.describe RecipeForm, type: :model do
  let(:user) { create(:user) }

  describe 'validations' do
    it 'is valid with title and description' do
      form = RecipeForm.new(title: 'タイトル', description: '説明', user_id: user.id)
      expect(form).to be_valid
    end

    it 'is invalid without title' do
      form = RecipeForm.new(title: '', description: '説明', user_id: user.id)
      expect(form).not_to be_valid
      expect(form.errors[:title]).to be_present
    end

    it 'is invalid without description' do
      form = RecipeForm.new(title: 'タイトル', description: '', user_id: user.id)
      expect(form).not_to be_valid
      expect(form.errors[:description]).to be_present
    end

    it 'rejects title longer than 100 chars' do
      long_title = 'a' * 101
      form = RecipeForm.new(title: long_title, description: '説明', user_id: user.id)
      expect(form).not_to be_valid
      expect(form.errors[:title]).to include('is too long (maximum is 100 characters)') if form.errors[:title].any?
    end
  end

  describe '#save' do
    context 'when creating a new recipe with existing tag ids' do
      it 'creates a recipe and associates tags' do
        tags = create_list(:tag, 2)
        form = RecipeForm.new(title: 'タイトル', description: '説明', user_id: user.id, tag_ids: tags.map(&:id))

        expect { form.save }.to change { Recipe.count }.by(1)
        recipe = Recipe.last
        expect(recipe.tags.pluck(:id)).to match_array(tags.map(&:id))
      end
    end

    context 'when new_tag_names are provided' do
      it 'creates new tags and associates them' do
        form = RecipeForm.new(title: 'タイトル', description: '説明', user_id: user.id, new_tag_names: 'たべもの,おやつ')

        expect { form.save }.to change { Tag.count }.by(2)
        recipe = Recipe.last
        expect(recipe.tags.pluck(:name)).to include('たべもの', 'おやつ')
      end
    end

    context 'when invalid' do
      it 'does not create recipe' do
        form = RecipeForm.new(title: '', description: '', user_id: user.id)
        expect(form.save).to be_falsey
        expect(Recipe.count).to eq(0)
      end
    end
  end
end
