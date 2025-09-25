require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:recipe) do
    create(:recipe, user: other_user, image: fixture_file_upload(Rails.root.join('public/images/test_image.png'), 'image/png'))
  end

  before do
    sign_in user
    allow_any_instance_of(ApplicationController).to receive(:basic_auth).and_return(true)
  end

  describe 'POST /recipes/:recipe_id/likes' do
    it 'ログインユーザーはいいねできる' do
      expect do
        post recipe_likes_path(recipe)
      end.to change(Like, :count).by(1)
      expect(response).to redirect_to(recipe_path(recipe))
    end

    it '同じレシピに複数回いいねはできない' do
      create(:like, user: user, recipe: recipe)
      expect do
        post recipe_likes_path(recipe)
      end.not_to change(Like, :count)
      expect(response).to redirect_to(recipe_path(recipe))
    end

    it '未ログインユーザーはリダイレクトされる' do
      sign_out user
      expect do
        post recipe_likes_path(recipe)
      end.not_to change(Like, :count)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'DELETE /recipes/:recipe_id/likes/:id' do
    let!(:like) { create(:like, user: user, recipe: recipe) }

    it '自分のいいねを削除できる' do
      expect do
        delete recipe_like_path(recipe, like)
      end.to change(Like, :count).by(-1)
      expect(response).to redirect_to(recipe_path(recipe))
    end

    it '他人のいいねは削除できない' do
      other_like = create(:like, user: other_user, recipe: recipe)
      expect do
        delete recipe_like_path(recipe, other_like)
      end.not_to change(Like, :count)
      expect(response).to redirect_to(recipe_path(recipe))
    end
  end
end
