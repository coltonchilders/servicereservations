require 'rails_helper'

RSpec.describe Api::V1::ReservationsController do
  describe "GET #index" do
    let!(:reservations) { create_list(:reservation, 20) }
    before do
      get :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Loaded reservations'
    end

    it "returns all the reservations" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].count).to eq 20
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0].keys).to match_array(["id", "customer_id", "vehicle_id", "year", "month", "day", "hour", "minute", "employee", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0]['year']).to eq reservations[19].year
      expect(json_response['data'][0]['month']).to eq reservations[19].month
    end
  end

  describe "GET #reservations_for_customer" do
    let!(:reservations) { create_list(:reservation, 20) }
    before do
      get :reservations_for_customer, params: {customer: reservations[0].customer.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      customer = reservations[0].customer
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq "Loaded reservations for customer: #{customer.first_name} #{customer.last_name}"
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0].keys).to match_array(["id", "customer_id", "vehicle_id", "year", "month", "day", "hour", "minute", "employee", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0]['year']).to eq reservations[0].year
      expect(json_response['data'][0]['month']).to eq reservations[0].month
      expect(json_response['data'][0]['customer_id']).to eq reservations[0].customer.id
    end
  end

  describe "GET #reservations_for_customer not found" do
    let!(:reservations) { create_list(:reservation, 20) }
    before do
      get :reservations_for_customer, params: {customer: 999}
    end

    it "returns http not_found" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Customer not found'
    end
  end

  describe "GET #reservations_for_vehicle" do
    let!(:reservations) { create_list(:reservation, 20) }
    before do
      get :reservations_for_vehicle, params: {vehicle: reservations[0].vehicle.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      vehicle = reservations[0].vehicle
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq "Loaded reservations for vehicle: #{vehicle.make} #{vehicle.model} #{vehicle.year}"
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0].keys).to match_array(["id", "customer_id", "vehicle_id", "year", "month", "day", "hour", "minute", "employee", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0]['year']).to eq reservations[0].year
      expect(json_response['data'][0]['month']).to eq reservations[0].month
      expect(json_response['data'][0]['vehicle_id']).to eq reservations[0].vehicle.id
    end
  end

  describe "GET #reservations_for_vehicle not found" do
    let!(:reservations) { create_list(:reservation, 20) }
    before do
      get :reservations_for_vehicle, params: {vehicle: 999}
    end

    it "returns http not_found" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Vehicle not found'
    end
  end

  describe "GET #show" do
    let!(:reservations) { create_list(:reservation, 20) }
    before do
      get :show, params: {id: reservations[0].id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Loaded reservation'
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].keys).to match_array(["id", "customer_id", "vehicle_id", "year", "month", "day", "hour", "minute", "employee", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['year']).to eq reservations[0].year
      expect(json_response['data']['month']).to eq reservations[0].month
    end
  end

  describe "GET #show not found" do
    let(:reservation) { create(:reservation) }
    before do
      get :show, params: {id: reservation.id + 1}
    end

    it "returns http not_found" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Reservation not found'
    end
  end

  describe "POST #create" do
    let(:customer) { create(:customer) }
    let(:vehicle) { create(:vehicle) }
    let(:reservation) { build(:reservation) }

    before do
      post :create, params: {vehicle: vehicle.id, reservation: reservation.attributes}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Saved reservation'
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].keys).to match_array(["id", "customer_id", "vehicle_id", "year", "month", "day", "hour", "minute", "employee", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['year']).to eq reservation.year
      expect(json_response['data']['month']).to eq reservation.month
    end

    it "creates the reservation", skip_before: true do
      expect{
        post :create, params: {vehicle: vehicle.id, reservation: reservation.attributes}
      }.to change(Reservation, :count).by(1)
    end
  end

  describe "POST #create failure" do
    let(:customer) { create(:customer) }
    let(:vehicle) { create(:vehicle) }
    let(:reservation) { build(:reservation) }
    before do
      reservation.year = nil
      post :create, params: {vehicle: vehicle.id, reservation: reservation.attributes}
    end

    it "returns http unprocessable_entity" do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Reservation not saved'
    end

    it "does not create the reservation", skip_before: true do
      expect{
        reservation.year = nil
        post :create, params: {vehicle: vehicle.id, reservation: reservation.attributes}
      }.to change(Reservation, :count).by(0)
    end
  end

  describe "PUT #update" do
    let(:reservation) { create(:reservation) }
    before do
      put :update, params: {id: reservation.id, reservation: { year: 2020 }}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Updated reservation'
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].keys).to match_array(["id", "customer_id", "vehicle_id", "year", "month", "day", "hour", "minute", "employee", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['year']).to eq 2020
      expect(json_response['data']['month']).to eq reservation.month
    end
  end

  describe "PUT #update not found" do
    let(:reservation) { create(:reservation) }
    before do
      put :update, params: {id: reservation.id + 1, reservation: { year: 2020 }}
    end

    it "returns http not_found" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Reservation not found'
    end
  end

  describe "DELETE #destroy" do
    let(:reservation) { create(:reservation) }
    before do
      delete :destroy, params: {id: reservation.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Deleted reservation'
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].keys).to match_array(["id", "customer_id", "vehicle_id", "year", "month", "day", "hour", "minute", "employee", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['year']).to eq reservation.year
      expect(json_response['data']['month']).to eq reservation.month
    end

    it "destroys the reservation", skip_before: true do
      reservation = create(:reservation)
      expect{
        delete :destroy, params: {id: reservation.id}
      }.to change(Reservation, :count).by(-1)
    end
  end

  describe "DELETE #destroy not found" do
    let(:reservation) { create(:reservation) }
    before do
      delete :destroy, params: {id: reservation.id + 1}
    end

    it "returns http not_found" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Reservation not found'
    end

    it "does not destroy the reservation", skip_before: true do
      reservation = create(:reservation)
      expect{
        delete :destroy, params: {id: ''}
      }.to change(Reservation, :count).by(0)
    end
  end
end
