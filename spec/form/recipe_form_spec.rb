require 'rails_helper'

RSpec.describe RecipeForm, type: :model do
  let(:user) { create(:user) }
  let(:image) { fixture_file_upload(Rails.root.join('public/images/test_image.png'), 'image/png') }

  describe 'レシピ投稿バリデーション' do
    context '投稿できる場合' do
      it 'title, description, user_id, image があれば有効' do
        form = RecipeForm.new(title: 'タイトル', description: '説明', user_id: user.id, image: image)
        expect(form).to be_valid
      end

      it 'titleが100文字以下であれば有効' do
        form = RecipeForm.new(title: 'a' * 100, description: '説明', user_id: user.id, image: image)
        expect(form).to be_valid
      end

      it 'descriptionが1000文字以下であれば有効' do
        form = RecipeForm.new(title: 'タイトル', description: 'a' * 1000, user_id: user.id, image: image)
        expect(form).to be_valid
      end
    end

    context '投稿できない場合' do
      it 'titleが空では無効' do
        form = RecipeForm.new(title: '', description: '説明', user_id: user.id, image: image)
        expect(form).not_to be_valid
        expect(form.errors[:title]).to include("can't be blank")
      end

      it 'descriptionが空では無効' do
        form = RecipeForm.new(title: 'タイトル', description: '', user_id: user.id, image: image)
        expect(form).not_to be_valid
        expect(form.errors[:description]).to include("can't be blank")
      end

      it 'titleが101文字以上では無効' do
        form = RecipeForm.new(title: 'a' * 101, description: '説明', user_id: user.id, image: image)
        expect(form).not_to be_valid
        expect(form.errors[:title]).to include('is too long (maximum is 100 characters)')
      end
    end
  end

  describe '#save' do
    context '既存タグIDが指定された場合' do
      it 'レシピを作成しタグを関連付ける' do
        tags = create_list(:tag, 2)
        form = RecipeForm.new(
          title: 'タイトル',
          description: '説明',
          user_id: user.id,
          tag_ids: tags.map(&:id),
          image: image
        )

        expect { form.save }.to change { Recipe.count }.by(1)
        recipe = Recipe.last
        expect(recipe.tags.pluck(:id)).to match_array(tags.map(&:id))
      end
    end

    context 'new_tag_names が指定された場合' do
      it '新しいタグを作成し関連付ける' do
        form = RecipeForm.new(
          title: 'タイトル',
          description: '説明',
          user_id: user.id,
          new_tag_names: 'たべもの,おやつ',
          image: image
        )

        expect { form.save }.to change { Tag.count }.by(2)
        recipe = Recipe.last
        expect(recipe.tags.pluck(:name)).to include('たべもの', 'おやつ')
      end
    end

    context '画像必須の場合' do
      it '画像が添付されなければ保存できない' do
        form = RecipeForm.new(
          title: 'タイトル',
          description: '説明',
          user_id: user.id,
          image: nil
        )
        expect(form.valid?).to be_falsey
        expect(form.errors[:image]).to include("can't be blank")
      end
    end

    context '無効な入力の場合' do
      it 'レシピを作成しない' do
        form = RecipeForm.new(title: '', description: '', user_id: user.id)
        expect(form.save).to be_falsey
        expect(Recipe.count).to eq(0)
      end
    end
  end
end
