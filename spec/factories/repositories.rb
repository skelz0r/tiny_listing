FactoryGirl.define do
  factory :repository do
    link { generate(:repository_link) } 
    
    after(:build) do |repository, evaluator|
      build(:loot, repository: repository)
    end
  end
end
