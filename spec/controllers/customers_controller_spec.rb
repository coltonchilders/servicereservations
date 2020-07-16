require 'rails_helper'

RSpec.describe Api::V1::CustomersController do
  describe "GET #index" do
    let!(:customers) { create_list(:customer, 20) }
    before do
      get :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Loaded customers'
    end

    it "returns all the customers" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].count).to eq 20
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0].keys).to match_array(["id", "first_name", "last_name", "phone_number", "email", "address_line1", "address_line2", "city", "state", "zip", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0]['first_name']).to eq customers[19].first_name
      expect(json_response['data'][0]['last_name']).to eq customers[19].last_name
    end
  end

  describe "GET #show" do
    let!(:customers) { create_list(:customer, 20) }
    before do
      get :show, params: {id: customers[0].id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Loaded customer'
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].keys).to match_array(["id", "first_name", "last_name", "phone_number", "email", "address_line1", "address_line2", "city", "state", "zip", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['first_name']).to eq customers[0].first_name
      expect(json_response['data']['last_name']).to eq customers[0].last_name
    end
  end

  describe "GET #show not found" do
    let(:customer) { create(:customer) }
    before do
      get :show, params: {id: customer.id + 1}
    end

    it "returns http not_found" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Customer not found'
    end
  end

  describe "POST #create" do
    let(:customer) { build(:customer) }
    before do
      post :create, params: {customer: customer.attributes}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Saved customer'
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].keys).to match_array(["id", "first_name", "last_name", "phone_number", "email", "address_line1", "address_line2", "city", "state", "zip", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['first_name']).to eq customer.first_name
      expect(json_response['data']['last_name']).to eq customer.last_name
    end

    it "creates the customer", skip_before: true do
      expect{
        post :create, params: {customer: customer.attributes}
      }.to change(Customer, :count).by(1)
    end
  end

  describe "POST #create failure" do
    let(:customer) { build(:customer) }
    before do
      customer.first_name = nil
      post :create, params: {customer: customer.attributes}
    end

    it "returns http unprocessable_entity" do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Customer not saved'
    end

    it "does not create the customer", skip_before: true do
      expect{
        customer.first_name = nil
        post :create, params: {customer: customer.attributes}
      }.to change(Customer, :count).by(0)
    end
  end

  describe "PUT #update" do
    let(:customer) { create(:customer) }
    before do
      put :update, params: {id: customer.id, customer: { first_name: 'Colton' }}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Updated customer'
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].keys).to match_array(["id", "first_name", "last_name", "phone_number", "email", "address_line1", "address_line2", "city", "state", "zip", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['first_name']).to eq 'Colton'
      expect(json_response['data']['last_name']).to eq customer.last_name
    end
  end

  describe "PUT #update not found" do
    let(:customer) { create(:customer) }
    before do
      put :update, params: {id: customer.id + 1, customer: { first_name: 'Colton' }}
    end

    it "returns http not_found" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Customer not found'
    end
  end

  describe "DELETE #destroy" do
    let(:customer) { create(:customer) }
    before do
      delete :destroy, params: {id: customer.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Deleted customer'
    end

    it "JSON body response contains expected attributes" do
      json_response = JSON.parse(response.body)
      expect(json_response['data'].keys).to match_array(["id", "first_name", "last_name", "phone_number", "email", "address_line1", "address_line2", "city", "state", "zip", "created_at", "updated_at"])
    end

    it "attributes to have the correct values" do
      json_response = JSON.parse(response.body)
      expect(json_response['data']['first_name']).to eq customer.first_name
      expect(json_response['data']['last_name']).to eq customer.last_name
    end

    it "destroys the customer", skip_before: true do
      customer = create(:customer)
      expect{
        delete :destroy, params: {id: customer.id}
      }.to change(Customer, :count).by(-1)
    end
  end

  describe "DELETE #destroy not found" do
    let(:customer) { create(:customer) }
    before do
      delete :destroy, params: {id: ''}
    end

    it "returns http not_found" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns the appropriate message" do
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Customer not found'
    end

    it "does not destroy the customer", skip_before: true do
      customer = create(:customer)
      expect{
        delete :destroy, params: {id: ''}
      }.to change(Customer, :count).by(0)
    end
  end
end
