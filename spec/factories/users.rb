FactoryGirl.define do
  sequence(:email) { |n| "person#{n}@mail.com" }

  factory :user do
    email
    password "password"
  end
end
