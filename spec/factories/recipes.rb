FactoryBot.define do
  factory :recipe do
    title { '子供が喜ぶ！ふわふわクッキー' }
    description { '甘くて美味しいクッキーのレシピです。子供が喜ぶ味付けになっています。' }
    association :user

    # デフォルトで画像を添付（必須だから）
    after(:build) do |recipe|
      recipe.image.attach(
        io: File.open(Rails.root.join('public/images/test_image.png')),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
    end

    trait :with_tags do
      after(:create) do |recipe|
        tags = create_list(:tag, 2)
        recipe.tags << tags
      end
    end

    trait :with_likes do
      after(:create) do |recipe|
        users = create_list(:user, 3)
        users.each { |user| create(:like, user: user, recipe: recipe) }
      end
    end

    trait :with_comments do
      after(:create) do |recipe|
        users = create_list(:user, 2)
        users.each { |user| create(:comment, user: user, recipe: recipe, content: '美味しそう！') }
      end
    end
  end
end
