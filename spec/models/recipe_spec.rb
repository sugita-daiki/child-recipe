require 'rails_helper'

RSpec.describe Recipe, type: :model do
  before do
    @recipe = FactoryBot.build(:recipe)
  end

  describe 'レシピ新規投稿' do
    context '投稿できる場合' do
      it 'title, description, image, userが存在すれば登録できる' do
        expect(@recipe).to be_valid
      end

      it 'titleが100文字以下であれば登録できる' do
        @recipe.title = 'a' * 100
        expect(@recipe).to be_valid
      end

      it 'descriptionが1000文字以下であれば登録できる' do
        @recipe.description = 'a' * 1000
        expect(@recipe).to be_valid
      end
    end

    context '投稿できない場合' do
      it 'titleが空では登録できない' do
        @recipe.title = ''
        @recipe.valid?
        expect(@recipe.errors.full_messages).to include("Title can't be blank")
      end

      it 'titleが101文字以上では登録できない' do
        @recipe.title = 'a' * 101
        @recipe.valid?
        expect(@recipe.errors.full_messages).to include('Title is too long (maximum is 100 characters)')
      end

      it 'descriptionが空では登録できない' do
        @recipe.description = ''
        @recipe.valid?
        expect(@recipe.errors.full_messages).to include("Description can't be blank")
      end

      it 'descriptionが1001文字以上では登録できない' do
        @recipe.description = 'a' * 1001
        @recipe.valid?
        expect(@recipe.errors.full_messages).to include('Description is too long (maximum is 1000 characters)')
      end

      it 'userが紐付いていなければ登録できない' do
        @recipe.user = nil
        @recipe.valid?
        expect(@recipe.errors.full_messages).to include('User must exist')
      end

      it 'imageが添付されていなければ登録できない' do
        @recipe.image.detach
        @recipe.valid?
        expect(@recipe.errors.full_messages).to include("Image can't be blank")
      end
    end
  end
end
