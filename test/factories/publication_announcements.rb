FactoryGirl.define do
  factory :publication_announcement do
    sequence(:title) { |index| "Stats announcement #{index}" }
    summary "Summary of announcement"
    release_date 1.year.from_now
    
    association :organisation
    association :creator, factory: :policy_writer
  end
end
