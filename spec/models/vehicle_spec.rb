require 'rails_helper'

RSpec.describe Vehicle do
  describe 'destroy vehicle' do
    it 'destroys vehicle' do
      vehicle = create(:vehicle)
      expect{ vehicle.destroy }.to change(Vehicle, :count).by(-1)
    end

    it 'destroys associated vehicles' do
      vehicle = create(:vehicle)
      create_list(:reservation, 5) do |reservation|
        reservation.vehicle = vehicle
        reservation.save
      end

      expect{ vehicle.destroy }.to change(Reservation, :count).by(-5)
    end
  end
end
