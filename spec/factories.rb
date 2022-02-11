FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    email { "test@example.com" }
    password { "password" }
    admin { true }
  end
end