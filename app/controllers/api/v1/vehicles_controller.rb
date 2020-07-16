module Api
  module V1
    class VehiclesController < ApplicationController
      def index
        vehicles = Vehicle.order('created_at DESC')
        if vehicles.empty?
          render json: {status: 'SUCCESS', message: 'No vehicles found.'}, status: :ok
        else
          render json: {status: 'SUCCESS', message: 'Loaded vehicles', data: vehicles}, status: :ok
        end
      end

      def vehicles_for_customer
        begin
          customer = Customer.find(params[:customer])
        rescue => e
          render json: {status: 'ERROR', message: 'Customer not found', data: e.message}, status: :not_found
        else
          vehicles = customer.vehicles
          if vehicles.empty?
            render json: {status: 'SUCCESS', message: "No vehicles found for this customer: #{customer.first_name} #{customer.last_name}"}, status: :ok
          else
            render json: {status: 'SUCCESS', message: "Loaded vehicles for customer: #{customer.first_name} #{customer.last_name}", data: vehicles}, status: :ok
          end
        end
      end

      def show
        begin
          vehicle = Vehicle.find(params[:id])
        rescue => e
          render json: {status: 'ERROR', message: 'Vehicle not found', data: e.message}, status: :not_found
        else
          render json: {status: 'SUCCESS', message: 'Loaded vehicle', data: vehicle}, status: :ok
        end
      end

      def create
        begin
          customer = Customer.find(params[:customer])
        rescue => e
          render json: {status: 'ERROR', message: 'Customer not found', data: e.message}, status: :not_found
        else
          vehicle = customer.vehicles.build(vehicle_params)

          if vehicle.save
            render json: {status: 'SUCCESS', message: 'Saved vehicle', data: vehicle}, status: :ok
          else
            render json: {status: 'ERROR', message: 'Vehicle not saved', data: vehicle.errors}, status: :unprocessable_entity
          end
        end
      end

      def destroy
        begin
          vehicle = Vehicle.find(params[:id])
        rescue => e
          render json: {status: 'ERROR', message: 'Vehicle not found', data: e.message}, status: :not_found
        else
          if vehicle.destroy
            render json: {status: 'SUCCESS', message: 'Deleted vehicle', data: vehicle}, status: :ok
          else
            render json: {status: 'ERROR', message: 'Vehicle not deleted', data: vehicle.errors}, status: :unprocessable_entity
          end
        end
      end

      def update
        begin
          vehicle = Vehicle.find(params[:id])
        rescue => e
          render json: {status: 'ERROR', message: 'Vehicle not found', data: e.message}, status: :not_found
        else
          if vehicle.update(vehicle_params)
            render json: {status: 'SUCCESS', message: 'Updated vehicle', data: vehicle}, status: :ok
          else
            render json: {status: 'ERROR', message: 'Vehicle not updated', data: vehicle.errors}, status: :unprocessable_entity
          end
        end
      end

      private

      def vehicle_params
        params.require(:vehicle).permit(:make, :model, :year, :vin, :color, :mileage, :license)
      end
    end
  end
end
