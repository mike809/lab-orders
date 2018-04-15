FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    username { UniqueUsernameGenerator.for_user(self) }
    email { "#{self.username}@estomatologia.pucmm.edu.do" }

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

    factory :administrator do
      role :administrator
    end
  end
end
