# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create sample customers
15.times do
  Customer.create({
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone_number: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.email,
    address_line1: Faker::Address.street_address,
    address_line2: Faker::Address.secondary_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip: Faker::Address.zip,
    })
end

# Create sample vehicles
customers = Customer.all
customers.each do |customer|
  Vehicle.create({
    customer_id: customer.id,
    make: Faker::Vehicle.make,
    model: Faker::Vehicle.model,
    year: Faker::Vehicle.year,
    vin: Faker::Vehicle.vin,
    color: Faker::Vehicle.color,
    mileage: Faker::Vehicle.mileage,
    license: Faker::Vehicle.license_plate,
    })
end

# Create sample reservations
vehicles = Vehicle.all
vehicles.each do |vehicle|
  Reservation.create({
    customer_id: vehicle.customer.id,
    vehicle_id: vehicle.id,
    year: Faker::Number.within(range: 2000..2020),
    month: Faker::Number.within(range: 1..12),
    day: Faker::Number.within(range: 1..27),
    hour: Faker::Number.within(range: 1..23),
    minute: Faker::Number.within(range: 0..59),
    employee: Faker::FunnyName.name,
    })
end
