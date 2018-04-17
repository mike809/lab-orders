FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    username { UniqueUsernameGenerator.for_user(self) if full_name.present? }
    email { "#{username}@estomatologia.pucmm.edu.do" }

    factory :student do
      role :student

      trait :with_order do
        after(:create) do |user|
          create(:order, student: user)
        end
      end
    end

    factory :teacher do
      role :teacher
    end

    factory :patient do
      role :patient
    end

    factory :administrator, aliases: [:admin] do
      role :administrator
    end
  end
end
