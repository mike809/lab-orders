FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.user_name }
    full_name { Faker::Name.name }

    factory :student do
      role :student
    end

    factory :teacher do
      role :teacher
    end

    factory :patient do
      role :patient
    end

    factory :administrator do
      role :administrator
    end
  end
end
