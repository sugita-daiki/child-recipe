FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { password }
    profile { '自己紹介文です' }
    nickname { Faker::Name.name }

    trait :with_recipes do
      after(:create) do |user|
        create_list(:recipe, 3, user: user)
      end
    end

    trait :with_likes do
      after(:create) do |user|
        # 他人のレシピを2件作成
        other_users = create_list(:user, 2)
        recipes = other_users.map { |u| create(:recipe, user: u) }

        recipes.each do |recipe|
          create(:like, user: user, recipe: recipe)
        end
      end
    end
  end
end
