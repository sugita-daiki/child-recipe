require 'rails_helper'

RSpec.describe 'レシピ投稿', type: :system do
  include SystemHelpers

  before do
    @user = FactoryBot.create(:user)
    @recipe = FactoryBot.build(:recipe)
  end

  context 'レシピ投稿ができるとき' do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      login_as(@user)
      expect(page).to have_current_path(root_path)

      # 投稿ページへのリンクを確認
      expect(page).to have_content('新しいレシピを投稿')

      # 投稿ページへ遷移
      basic_auth_visit(new_recipe_path)
      fill_in 'レシピタイトル', with: @recipe.title
      fill_in 'レシピ詳細', with: @recipe.description
      attach_file 'レシピ画像（必須）', Rails.root.join('public/images/test_image.png')

      # タグがある場合（スキップ（任意フィールド））
      # fill_in '新しいタグを追加', with: '和食, 簡単'

      # 投稿するとRecipeモデルのカウントが1増える
      expect do
        click_button 'おやつレシピを投稿'
      end.to change { Recipe.count }.by(1)

      # トップページに投稿したレシピが表示される
      expect(page).to have_content(@recipe.title)
      expect(page).to have_content(@recipe.description)
    end
  end

  context 'レシピ投稿ができないとき' do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      basic_auth_visit(root_path)
      expect(page).to have_no_content('新しいレシピを投稿')
    end
  end
end

RSpec.describe 'レシピ編集', type: :system do
  include SystemHelpers

  before do
    @recipe1 = FactoryBot.create(:recipe)
    @recipe2 = FactoryBot.create(:recipe)
  end

  context '編集できるとき' do
    it 'ログインユーザーは自分の投稿を編集できる' do
      # ログイン
      login_as(@recipe1.user)

      # レシピ詳細ページに移動して編集リンクを確認
      basic_auth_visit(recipe_path(@recipe1))
      expect(page).to have_link '編集', href: edit_recipe_path(@recipe1)

      # 編集ページに遷移
      basic_auth_visit(edit_recipe_path(@recipe1))
      fill_in 'レシピタイトル', with: "#{@recipe1.title}（編集済み）"
      fill_in 'レシピ詳細', with: "#{@recipe1.description}（編集済み）"
      # 画像は既存のものを使用（新しい画像を添付しない）

      # 編集してもRecipe.countは変わらない
      expect do
        click_button 'おやつレシピを更新'
      end.to change { Recipe.count }.by(0)

      # 編集後はレシピ詳細ページにリダイレクトされる
      expect(page).to have_current_path(recipe_path(@recipe1))
      expect(page).to have_content("#{@recipe1.title}（編集済み）")
      expect(page).to have_content("#{@recipe1.description}（編集済み）")
    end
  end

  context '編集できないとき' do
    it '他人の投稿は編集できない' do
      login_as(@recipe1.user)

      # 他人の投稿には編集リンクがない
      expect(page).to have_no_link '編集', href: edit_recipe_path(@recipe2)
    end

    it 'ログインしていないと編集できない' do
      basic_auth_visit(root_path)
      expect(page).to have_no_link '編集', href: edit_recipe_path(@recipe1)
    end
  end
end

RSpec.describe 'レシピ削除', type: :system do
  include SystemHelpers

  before do
    @recipe1 = FactoryBot.create(:recipe)
    @recipe2 = FactoryBot.create(:recipe)
  end

  context '削除できるとき' do
    it 'ログインユーザーは自分の投稿を削除できる' do
      login_as(@recipe1.user)

      # レシピ詳細ページに移動して削除リンクを確認
      basic_auth_visit(recipe_path(@recipe1))
      expect(page).to have_link '削除', href: recipe_path(@recipe1)

      expect do
        # 削除ボタンをクリック
        click_link '削除', href: recipe_path(@recipe1)
      end.to change { Recipe.count }.by(-1)

      expect(page).to have_no_content(@recipe1.title)
    end
  end

  context '削除できないとき' do
    it '他人の投稿は削除できない' do
      login_as(@recipe1.user)

      expect(page).to have_no_link '削除', href: recipe_path(@recipe2)
    end

    it '未ログインだと削除できない' do
      basic_auth_visit(root_path)
      expect(page).to have_no_link '削除', href: recipe_path(@recipe1)
    end
  end
end

RSpec.describe 'レシピ詳細', type: :system do
  include SystemHelpers

  before do
    @recipe = FactoryBot.create(:recipe)
  end

  it 'ログインユーザーは詳細ページでコメント投稿欄が見える' do
    login_as(@recipe.user)

    basic_auth_visit(recipe_path(@recipe))
    expect(page).to have_content(@recipe.title)
    expect(page).to have_content(@recipe.description)
    expect(page).to have_selector 'form'
  end

  it '未ログインユーザーは詳細ページに行けるがコメント投稿欄は出ない' do
    basic_auth_visit(recipe_path(@recipe))
    expect(page).to have_content(@recipe.title)
    expect(page).to have_content(@recipe.description)
    expect(page).to have_no_selector 'form'
  end
end
