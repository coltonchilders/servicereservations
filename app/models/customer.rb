class Customer < ApplicationRecord
  has_many :vehicles
  has_many :reservations

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true
  validates :address_line1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true

  before_destroy :destroy_vehicles

  def destroy_vehicles
    self.vehicles.destroy_all
  end
end
