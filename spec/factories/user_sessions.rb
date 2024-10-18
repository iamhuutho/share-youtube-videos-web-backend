FactoryBot.define do
  factory :user_session do
    association :user
    session_token { SecureRandom.hex(10) }
    expires_at { 1.hour.from_now }
    revoked { false }
  end
end
