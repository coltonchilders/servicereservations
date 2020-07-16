FactoryBot.define do
  factory :reservation do
    association :customer, factory: :customer
    association :vehicle, factory: :vehicle
    year {Faker::Number.within(range: 2000..2020)}
    month {Faker::Number.within(range: 1..12)}
    day {Faker::Number.within(range: 1..27)}
    hour {Faker::Number.within(range: 1..23)}
    minute {Faker::Number.within(range: 0..59)}
    employee {Faker::FunnyName.name}
  end
end
