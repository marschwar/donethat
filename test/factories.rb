require "factory_girl"

FactoryGirl.define do
  sequence(:uid) { |n| "UUID-#{n}"}
  sequence(:title) { |n| "Some title #{n}"}

  sequence(:identifier) { |n| "someone-#{n}@somewhere.com"}
  factory :user do
    identifier
    password "secret"
    type 'DeveloperUser'

    factory :twuser, class: TwitterUser do
      type 'TwitterUser'
    end
  end

  factory :trip do
    uid
    user
    title
    content 'any content'
    public false

    trait(:with_notes) do
      transient do
        note_count 10
      end

      after(:create) do |trip, evaluator|
        FactoryGirl.create_list(:note, evaluator.note_count, trip: trip)
      end
    end
  end

  factory :note do
    uid
    title
    trip
    content 'some content'
    note_date Date.yesterday

    trait :with_location do
      longitude 10.0
      latitude 5.0
    end
  end
end
