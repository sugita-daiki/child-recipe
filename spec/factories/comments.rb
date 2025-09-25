FactoryBot.define do
  factory :comment do
    content { '美味しそう！' }
    association :user
    association :recipe
  end
end
