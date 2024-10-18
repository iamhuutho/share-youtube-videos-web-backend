FactoryBot.define do
  factory :notification do
    title { "Sample Notification" }
    message { "This is a test notification." }
    association :user
  end
end