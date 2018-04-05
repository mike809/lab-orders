FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.user_name }
    full_name { Faker::Name.name }

    trait :student do
      role :student
    end

    trait :teacher do
      role :teacher
    end

    trait :patient do
      role :patient
    end

    trait :administrator do
      role :administrator
    end
  end
end
