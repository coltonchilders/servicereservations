require 'rails_helper'

RSpec.describe Customer do
  describe 'destroy customer' do
    it 'destroys customer' do
      customer = create(:customer)
      expect{ customer.destroy }.to change(Customer, :count).by(-1)
    end

    it 'destroys associated vehicles' do
      customer = create(:customer)
      create_list(:vehicle, 5) do |vehicle|
        vehicle.customer = customer
        vehicle.save
      end

      expect{ customer.destroy }.to change(Vehicle, :count).by(-5)
    end
  end
end
