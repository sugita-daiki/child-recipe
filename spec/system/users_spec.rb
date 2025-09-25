# spec/system/users_spec.rb
require 'rails_helper'

RSpec.describe 'ユーザー機能', type: :system do
  before do
    driven_by(:selenium_chrome_headless) # Chromeヘッドレスで動作
  end

  def basic_auth_visit(path)
    user = ENV['BASIC_AUTH_USER']
    password = ENV['BASIC_AUTH_PASSWORD']
    visit "http://#{user}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
  end

  describe 'ユーザー新規登録' do
    before do
      @user = FactoryBot.build(:user)
    end

    context 'ユーザー新規登録ができるとき' do
      it '正しい情報を入力すれば新規登録できトップページに移動する' do
        basic_auth_visit new_user_registration_path

        fill_in 'ニックネーム', with: @user.nickname
        fill_in 'メールアドレス', with: @user.email
        fill_in 'パスワード', with: @user.password
        fill_in 'パスワード（確認）', with: @user.password_confirmation
        fill_in '自己紹介', with: @user.profile

        expect  do
          find('input[name="commit"]').click
        end.to change { User.count }.by(1)

        expect(page).to have_current_path(root_path)
        expect(page).to have_content('ログアウト')
        expect(page).to have_no_content('新規登録')
        expect(page).to have_no_content('ログイン')
      end
    end

    context 'ユーザー新規登録ができないとき' do
      it '誤った情報では登録できず新規登録ページに戻る' do
        basic_auth_visit new_user_registration_path

        fill_in 'ニックネーム', with: ''
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        fill_in 'パスワード（確認）', with: ''
        fill_in '自己紹介', with: ''

        expect  do
          find('input[name="commit"]').click
        end.to change { User.count }.by(0)

        # 新規登録ページに留まることを確認
        expect(page).to have_current_path(new_user_registration_path)
        # フォームが再表示されることを確認
        expect(page).to have_content('新規登録')
        expect(page).to have_content('ニックネーム')
      end
    end
  end

  describe 'ログイン' do
    before do
      @user = FactoryBot.create(:user)
    end

    context 'ログインができるとき' do
      it '保存済みユーザー情報でログインできる' do
        basic_auth_visit new_user_session_path

        fill_in 'メールアドレス', with: @user.email
        fill_in 'パスワード', with: @user.password
        find('input[name="commit"]').click

        expect(page).to have_current_path(root_path)
        expect(page).to have_content('ログアウト')
        expect(page).to have_no_content('新規登録')
        expect(page).to have_no_content('ログイン')
      end
    end

    context 'ログインができないとき' do
      it '誤った情報ではログインできずログインページに戻る' do
        basic_auth_visit new_user_session_path

        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        find('input[name="commit"]').click

        # ログインページに留まることを確認
        expect(page).to have_current_path(new_user_session_path)
        # フォームが再表示されることを確認
        expect(page).to have_content('ログイン')
        expect(page).to have_content('メールアドレス')
      end
    end
  end
end
