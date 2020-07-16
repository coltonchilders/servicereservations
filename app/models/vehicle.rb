class Vehicle < ApplicationRecord
  belongs_to :customer
  has_many :reservations

  validates :customer, presence: true
  validates :make, presence: true
  validates :model, presence: true
  validates :year, presence: true
  validates :vin , presence: true
  validates :color, presence: true
  validates :mileage, presence: true
  validates :license, presence: true

  before_destroy :destroy_reservations

  def destroy_reservations
    self.reservations.destroy_all
  end
end
