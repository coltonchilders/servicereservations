module Api
  module V1
    class CustomersController < ApplicationController
      def index
        customers = Customer.order('created_at DESC')
        if customers.empty?
          render json: {status: 'SUCCESS', message: 'No customers found.'}, status: :ok
        else
          render json: {status: 'SUCCESS', message: 'Loaded customers', data: customers}, status: :ok
        end
      end

      def show
        begin
          customer = Customer.find(params[:id])
        rescue => e
          render json: {status: 'ERROR', message: 'Customer not found', data: e.message}, status: :not_found
        else
          render json: {status: 'SUCCESS', message: 'Loaded customer', data: customer}, status: :ok
        end
      end

      def create
        customer = Customer.new(customer_params)

        if customer.save
          render json: {status: 'SUCCESS', message: 'Saved customer', data: customer}, status: :ok
        else
          render json: {status: 'ERROR', message: 'Customer not saved', data: customer.errors}, status: :unprocessable_entity
        end
      end

      def destroy
        begin
          customer = Customer.find(params[:id])
        rescue => e
          render json: {status: 'ERROR', message: 'Customer not found', data: e.message}, status: :not_found
        else
          if customer.destroy
            render json: {status: 'SUCCESS', message: 'Deleted customer', data: customer}, status: :ok
          else
            render json: {status: 'ERROR', message: 'Customer not deleted', data: customer.errors}, status: :unprocessable_entity
          end
        end
      end

      def update
        begin
          customer = Customer.find(params[:id])
        rescue => e
          render json: {status: 'ERROR', message: 'Customer not found', data: e.message}, status: :not_found
        else
          if customer.update(customer_params)
            render json: {status: 'SUCCESS', message: 'Updated customer', data: customer}, status: :ok
          else
            render json: {status: 'ERROR', message: 'Customer not updated', data: customer.errors}, status: :unprocessable_entity
          end
        end
      end

      private

      def customer_params
        params.require(:customer).permit(:first_name, :last_name, :phone_number, :email, :address_line1, :address_line2, :city, :state, :zip)
      end
    end
  end
end
