# spec/factories/tags.rb
FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "タグ#{n}" }

    trait :with_recipes do
      after(:create) do |tag|
        recipes = create_list(:recipe, 3)
        tag.recipes << recipes
      end
    end

    trait :popular do
      after(:create) do |tag|
        recipes = create_list(:recipe, 5)
        tag.recipes << recipes
      end
    end
  end
end
