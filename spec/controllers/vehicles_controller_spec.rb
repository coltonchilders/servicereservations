require 'rails_helper'

RSpec.describe Api::V1::VehiclesController do
  describe "GET #index" do
    let!(:vehicles) { create_list(:vehicle, 20) }
    before do
      get :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Loaded vehicles'
    end

    it "returns all the vehicles" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].count).to eq 20
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0].keys).to match_array(["id", "customer_id", "make", "model", "year", "vin", "color", "mileage", "license", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0]['make']).to eq vehicles[19].make
      expect(json_response['data'][0]['model']).to eq vehicles[19].model
    end
  end

  describe "GET #vehicles_for_customer" do
    let!(:vehicles) { create_list(:vehicle, 20) }
    before do
      get :vehicles_for_customer, params: {customer: vehicles[0].customer.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      customer = vehicles[0].customer
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq "Loaded vehicles for customer: #{customer.first_name} #{customer.last_name}"
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0].keys).to match_array(["id", "customer_id", "make", "model", "year", "vin", "color", "mileage", "license", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0]['make']).to eq vehicles[0].make
      expect(json_response['data'][0]['model']).to eq vehicles[0].model
      expect(json_response['data'][0]['customer_id']).to eq vehicles[0].customer.id
    end
  end

  describe "GET #vehicles_for_customer not found" do
    let!(:vehicles) { create_list(:vehicle, 20) }
    before do
      get :vehicles_for_customer, params: {customer: 999}
    end

    it "returns http not_found" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the appropriate message" do
      customer = vehicles[0].customer
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Customer not found'
    end
  end

  describe "GET #show" do
    let!(:vehicles) { create_list(:vehicle, 20) }
    before do
      get :show, params: {id: vehicles[0].id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Loaded vehicle'
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].keys).to match_array(["id", "customer_id", "make", "model", "year", "vin", "color", "mileage", "license", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['make']).to eq vehicles[0].make
      expect(json_response['data']['model']).to eq vehicles[0].model
    end
  end

  describe "GET #show not found" do
    let(:vehicle) { create(:vehicle) }
    before do
      get :show, params: {id: vehicle.id + 1}
    end

    it "returns http not_found" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Vehicle not found'
    end
  end

  describe "POST #create" do
    let(:customer) { create(:customer) }
    let(:vehicle) { build(:vehicle) }

    before do
      post :create, params: {customer: customer.id, vehicle: vehicle.attributes}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Saved vehicle'
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].keys).to match_array(["id", "customer_id", "make", "model", "year", "vin", "color", "mileage", "license", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['make']).to eq vehicle.make
      expect(json_response['data']['model']).to eq vehicle.model
    end

    it "creates the vehicle", skip_before: true do
      expect{
        post :create, params: {customer: customer.id, vehicle: vehicle.attributes}
      }.to change(Vehicle, :count).by(1)
    end
  end

  describe "POST #create failure" do
    let(:customer) { create(:customer) }
    let(:vehicle) { build(:vehicle) }
    before do
      vehicle.make = nil
      post :create, params: {customer: customer.id, vehicle: vehicle.attributes}
    end

    it "returns http unprocessable_entity" do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Vehicle not saved'
    end

    it "does not create the vehicle", skip_before: true do
      expect{
        vehicle.make = nil
        post :create, params: {customer: customer.id, vehicle: vehicle.attributes}
      }.to change(Vehicle, :count).by(0)
    end
  end

  describe "PUT #update" do
    let(:vehicle) { create(:vehicle) }
    before do
      put :update, params: {id: vehicle.id, vehicle: { make: 'Tesla' }}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Updated vehicle'
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].keys).to match_array(["id", "customer_id", "make", "model", "year", "vin", "color", "mileage", "license", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['make']).to eq 'Tesla'
      expect(json_response['data']['model']).to eq vehicle.model
    end
  end

  describe "PUT #update not found" do
    let(:vehicle) { create(:vehicle) }
    before do
      put :update, params: {id: vehicle.id + 1, vehicle: { make: 'Tesla' }}
    end

    it "returns http not_found" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Vehicle not found'
    end
  end

  describe "DELETE #destroy" do
    let(:vehicle) { create(:vehicle) }
    before do
      delete :destroy, params: {id: vehicle.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Deleted vehicle'
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].keys).to match_array(["id", "customer_id", "make", "model", "year", "vin", "color", "mileage", "license", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['make']).to eq vehicle.make
      expect(json_response['data']['model']).to eq vehicle.model
    end

    it "destroys the vehicle", skip_before: true do
      vehicle = create(:vehicle)
      expect{
        delete :destroy, params: {id: vehicle.id}
      }.to change(Vehicle, :count).by(-1)
    end
  end

  describe "DELETE #destroy not found" do
    let(:vehicle) { create(:vehicle) }
    before do
      delete :destroy, params: {id: vehicle.id + 1}
    end

    it "returns http not_found" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Vehicle not found'
    end

    it "does not destroy the vehicle", skip_before: true do
      vehicle = create(:vehicle)
      expect{
        delete :destroy, params: {id: ''}
      }.to change(Vehicle, :count).by(0)
    end
  end
end
