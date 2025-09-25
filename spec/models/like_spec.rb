require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーション' do
    it 'userとrecipeがあれば有効である' do
      like = build(:like)
      expect(like).to be_valid
    end

    it '同じuserが同じrecipeに複数いいねすることはできない' do
      like = create(:like)
      duplicate_like = build(:like, user: like.user, recipe: like.recipe)

      expect(duplicate_like).to be_invalid
      expect(duplicate_like.errors[:user_id]).to include('は既にこのレシピにいいねしています')
    end
  end

  describe 'アソシエーション' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:recipe) }
  end
end
