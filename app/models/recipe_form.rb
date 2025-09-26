class RecipeForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :title, :description, :image, :user_id, :tag_ids, :new_tag_names, :recipe_id

  def new_record?
    recipe_id.blank?
  end

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :user_id, presence: true
  # 画像は新規作成時のみ必須、編集時は任意
  validates :image, presence: true, if: :new_record?

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      recipe = Recipe.new(
        title: title,
        description: description,
        user_id: user_id,
        image: image
      )
      recipe.save!
      recipe.image.attach(image) if image.present?

      # 既存タグの関連付け
      recipe.tags << Tag.where(id: tag_ids) if tag_ids.present?

      # 新しいタグの作成と関連付け
      if new_tag_names.present?
        new_tag_names.split(',').each do |tag_name|
          tag_name = tag_name.strip
          next if tag_name.blank?

          tag = Tag.find_or_create_by(name: tag_name)
          recipe.tags << tag unless recipe.tags.include?(tag)
        end
      end
      recipe.save!
      recipe
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  def update
    return false unless valid?

    ActiveRecord::Base.transaction do
      recipe = Recipe.find(recipe_id)

      # レシピの基本情報を更新
      recipe.update!(
        title: title,
        description: description
      )

      # 画像の更新（新しい画像が提供された場合のみ）
      recipe.image.attach(image) if image.present?

      # タグの更新（既存のタグを全て削除してから新しいタグを追加）
      recipe.tags.clear

      # 既存タグの関連付け
      recipe.tags << Tag.where(id: tag_ids) if tag_ids.present?

      # 新しいタグの作成と関連付け
      if new_tag_names.present?
        new_tag_names.split(',').each do |tag_name|
          tag_name = tag_name.strip
          next if tag_name.blank?

          tag = Tag.find_or_create_by(name: tag_name)
          recipe.tags << tag unless recipe.tags.include?(tag)
        end
      end

      recipe
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end
end
