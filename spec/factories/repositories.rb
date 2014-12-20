FactoryGirl.define do
  factory :repository do
    user
    link { generate(:repository_link) }

    after(:build) do |repository, evaluator|
      build(:loot, repository: repository)
    end
  end
end
