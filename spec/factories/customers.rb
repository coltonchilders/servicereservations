FactoryBot.define do
  factory :customer do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    phone_number {Faker::PhoneNumber.phone_number}
    email {Faker::Internet.email}
    address_line1 {Faker::Address.street_address}
    address_line2 {Faker::Address.secondary_address}
    city {Faker::Address.city}
    state {Faker::Address.state}
    zip {Faker::Address.zip}
  end
end
