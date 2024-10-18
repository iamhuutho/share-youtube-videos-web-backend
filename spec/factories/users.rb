FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "testuser#{n}" } # Avoid repeat username
    password { "password" }
  end
end
