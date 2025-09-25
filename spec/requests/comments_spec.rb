require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:recipe) { FactoryBot.create(:recipe) }

  describe 'POST /recipes/:recipe_id/comments' do
    context 'ログインユーザーの場合' do
      before do
        sign_in user
        allow_any_instance_of(ApplicationController).to receive(:basic_auth).and_return(true)
      end

      it '有効なコメントを作成できる' do
        expect do
          post recipe_comments_path(recipe),
               params: { comment: { content: '美味しそう！' } },
               headers: { 'ACCEPT' => 'application/json' }
        end.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('success')
        expect(json['message']).to eq('コメントを投稿しました')
      end

      it '無効なコメントは作成できない' do
        expect do
          post recipe_comments_path(recipe),
               params: { comment: { content: '' } },
               headers: { 'ACCEPT' => 'application/json' }
        end.not_to change(Comment, :count)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('error')
        expect(json['errors']).to include("Content can't be blank")
      end
    end

    context '未ログインユーザーの場合' do
      it 'コメントできず401が返る' do
        post recipe_comments_path(recipe),
             params: { comment: { content: '美味しそう！' } },
             headers: { 'ACCEPT' => 'application/json' }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
