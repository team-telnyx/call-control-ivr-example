FactoryBot.define do
  factory :user do
    telephone_number { Faker::PhoneNumber.phone_number }
  end

  factory :anonymized_connection do
    user1_id { create(:user).id }
    user2_id { create(:user).id }
    telephone_number { Faker::PhoneNumber.phone_number }
  end
end
