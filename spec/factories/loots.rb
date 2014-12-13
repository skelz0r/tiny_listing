FactoryGirl.define do
  factory :loot do
    after(:build) do |loot, evaluator|
      if loot.repository.blank?
        loot.repository = build(:repository)
      end
    end
  end
end
