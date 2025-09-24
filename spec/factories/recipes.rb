FactoryBot.define do
  factory :recipe do
    title { '子供が喜ぶ！ふわふわクッキー' }
    description { '甘くて美味しいクッキーのレシピです。子供が喜ぶ味付けになっています。' }
    association :user

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

    trait :with_image do
      after(:build) do |recipe|
        if defined?(ActiveStorage::Blob)
          begin
            recipe.image.attach(
              io: StringIO.new('fake image content'),
              filename: 'test-image.png',
              content_type: 'image/png'
            )
          rescue StandardError
            nil
          end
        end
      end
    end
  end
end
