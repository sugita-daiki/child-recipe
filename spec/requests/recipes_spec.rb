require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:recipe) { create(:recipe, title: '子供が喜ぶ！ふわふわクッキー', user: user) }

  # 認証モック
  before do
    sign_in user
    allow_any_instance_of(ApplicationController).to receive(:basic_auth).and_return(true)
  end

  describe 'GET #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
      get recipes_path
      expect(response).to have_http_status(:success)
    end

    it '投稿済みのレシピタイトルがレスポンスに含まれる' do
      get recipes_path
      expect(response.body).to include(recipe.title)
    end

    it '検索パラメータを渡すと検索結果が表示される' do
      get recipes_path, params: { search: recipe.title }
      expect(response.body).to include(recipe.title)
    end
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get recipe_path(recipe)
      expect(response).to have_http_status(:success)
    end

    it 'レシピのタイトルがレスポンスに含まれる' do
      get recipe_path(recipe)
      expect(response.body).to include(recipe.title)
    end
  end

  describe 'GET #new' do
    it 'newアクションにリクエストすると正常にレスポンスが返ってくる' do
      get new_recipe_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        recipe_form: {
          title: 'テストタイトル',
          description: 'テスト説明',
          user_id: user.id,
          image: fixture_file_upload(Rails.root.join('public/images/test_image.png'), 'image/png'),
          tag_ids: [],
          new_tag_names: 'おやつ,簡単'
        }
      }
    end

    let(:invalid_params) do
      {
        recipe_form: {
          title: '',
          description: '',
          user_id: user.id,
          image: nil
        }
      }
    end

    context '有効なパラメータの場合' do
      it 'レシピが作成される' do
        expect do
          post recipes_path, params: valid_params
        end.to change(Recipe, :count).by(1)
      end

      it '作成後にrecipes_pathにリダイレクトする' do
        post recipes_path, params: valid_params
        expect(response).to redirect_to(recipes_path)
      end
    end

    context '無効なパラメータの場合' do
      it 'レシピは作成されない' do
        expect do
          post recipes_path, params: invalid_params
        end.not_to change(Recipe, :count)
      end

      it 'newテンプレートがレンダーされる' do
        post recipes_path, params: invalid_params
        expect(response.body).to include('form')
      end
    end
  end

  describe 'GET #edit' do
    it '自分のレシピ編集ページにアクセスできる' do
      get edit_recipe_path(recipe)
      expect(response).to have_http_status(:success)
    end

    it '他人のレシピ編集ページにアクセスするとリダイレクトされる' do
      sign_in other_user
      get edit_recipe_path(recipe)
      expect(response).to redirect_to(recipes_path)
    end
  end

  describe 'PATCH #update' do
    let(:update_params) do
      {
        recipe_form: {
          recipe_id: recipe.id,
          title: '更新タイトル',
          description: '更新説明',
          user_id: user.id,
          image: fixture_file_upload(Rails.root.join('public/images/test_image.png'), 'image/png'),
          tag_ids: [],
          new_tag_names: '更新タグ'
        }
      }
    end

    it '自分のレシピの場合、レシピを更新できる' do
      patch recipe_path(recipe), params: update_params
      expect(recipe.reload.title).to eq('更新タイトル')
    end

    it '更新後にshowページにリダイレクトされる' do
      patch recipe_path(recipe), params: update_params
      expect(response).to redirect_to(recipe_path(recipe))
    end

    it '他人のレシピの場合、レシピは更新されずrecipes_pathにリダイレクトされる' do
      sign_in other_user
      patch recipe_path(recipe), params: update_params
      expect(recipe.reload.title).not_to eq('更新タイトル')
      expect(response).to redirect_to(recipes_path)
    end
  end

  describe 'DELETE #destroy' do
    it '自分のレシピの場合、レシピを削除できる' do
      expect do
        delete recipe_path(recipe)
      end.to change(Recipe, :count).by(-1)
    end

    it '削除後にrecipes_pathにリダイレクトされる' do
      delete recipe_path(recipe)
      expect(response).to redirect_to(recipes_path)
    end

    it '他人のレシピの場合、レシピは削除されずrecipes_pathにリダイレクトされる' do
      sign_in other_user
      expect do
        delete recipe_path(recipe)
      end.not_to change(Recipe, :count)
      expect(response).to redirect_to(recipes_path)
    end
  end
end
