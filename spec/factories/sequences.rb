FactoryGirl.define do
  sequence(:repository_link) { |n| "http://whatever.site#{n}.net" }
end
