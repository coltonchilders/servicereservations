class Reservation < ApplicationRecord
  belongs_to :customer
  belongs_to :vehicle

  validates :customer, presence: true
  validates :vehicle, presence: true
  validates :year, presence: true
  validates :month, presence: true
  validates :day, presence: true
  validates :hour, presence: true
  validates :minute, presence: true
  validates :employee, presence: true
end
