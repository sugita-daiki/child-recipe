require 'rails_helper'

RSpec.describe 'コメント投稿', type: :system do
  include SystemHelpers
  before do
    @recipe = FactoryBot.create(:recipe) # コメント対象のレシピ
    @user = FactoryBot.create(:user)
    @comment_content = Faker::Lorem.sentence
  end

  context 'コメントできるとき' do
    it 'ログインしたユーザーはレシピ詳細ページでコメント投稿できる', js: true do
      # ログインする
      login_as(@user)

      # Basic認証付きでレシピ詳細ページにアクセス
      basic_auth_visit(recipe_path(@recipe))

      # コメントフォームに入力する
      fill_in 'コメントを入力してください', with: @comment_content

      # コメントを送信すると Comment.count が1増える
      expect do
        click_button 'コメント投稿'
        # 非同期処理待ち → コメントが表示されるまで待機
        expect(page).to have_content(@comment_content, wait: 5)
      end.to change { Comment.count }.by(1)

      # コメント内容と投稿者が表示されている
      expect(page).to have_content(@comment_content)
      expect(page).to have_content(@user.nickname)
    end
  end

  context 'コメントできないとき' do
    it 'ログインしていないとコメントフォームが表示されない' do
      # Basic認証付きでレシピ詳細ページにアクセス
      basic_auth_visit(recipe_path(@recipe))

      # フォームがないことを確認
      expect(page).to have_no_selector 'form#comment-form'
      expect(page).to have_no_button 'コメント投稿'
    end

    it '空のコメントを送信するとエラーになる', js: true do
      login_as(@user)
      basic_auth_visit(recipe_path(@recipe))

      # 空白文字のみのコメントを入力して送信
      fill_in 'comment_content', with: '   '

      # 空白のみのコメントを送信してもComment.countは変わらない
      expect do
        click_button 'コメント投稿'
        # 少し待機してAJAX処理を完了させる
        sleep 1
      end.not_to(change { Comment.count })

      # コメントが追加されていないことを確認
      expect(page).to have_no_content('   ')
    end
  end
end
