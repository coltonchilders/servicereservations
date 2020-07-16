FactoryBot.define do
  factory :vehicle do
    association :customer, factory: :customer
    make {Faker::Vehicle.make}
    model {Faker::Vehicle.model}
    year {Faker::Vehicle.year}
    vin {Faker::Vehicle.vin}
    color {Faker::Vehicle.color}
    mileage {Faker::Vehicle.mileage}
    license {Faker::Vehicle.license_plate}
  end
end
