FactoryBot.define do
  factory :user do
    email { "some_mail@example.com" }
    password { "some_password" }
  end
end