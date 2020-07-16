module Api
  module V1
    class ReservationsController < ApplicationController
      def index
        reservations = Reservation.order('created_at DESC')
        if reservations.empty?
          render json: {status: 'SUCCESS', message: 'No reservations found.'}, status: :ok
        else
          render json: {status: 'SUCCESS', message: 'Loaded reservations', data: reservations}, status: :ok
        end
      end

      def reservations_for_customer
        begin
          customer = Customer.find(params[:customer])
        rescue => e
          render json: {status: 'ERROR', message: 'Customer not found', data: e.message}, status: :not_found
        else
          reservations = customer.reservations
          if reservations.empty?
            render json: {status: 'SUCCESS', message: "No reservations found for this customer: #{customer.first_name} #{customer.last_name}"}, status: :ok
          else
            render json: {status: 'SUCCESS', message: "Loaded reservations for customer: #{customer.first_name} #{customer.last_name}", data: reservations}, status: :ok
          end
        end
      end

      def reservations_for_vehicle
        begin
          vehicle = Vehicle.find(params[:vehicle])
        rescue => e
          render json: {status: 'ERROR', message: 'Vehicle not found', data: e.message}, status: :not_found
        else
          reservations = vehicle.reservations
          if reservations.empty?
            render json: {status: 'SUCCESS', message: "No reservations found for this vehicle: #{vehicle.make} #{vehicle.model} #{vehicle.year}"}, status: :ok
          else
            render json: {status: 'SUCCESS', message: "Loaded reservations for vehicle: #{vehicle.make} #{vehicle.model} #{vehicle.year}", data: reservations}, status: :ok
          end
        end
      end

      def show
        begin
          reservation = Reservation.find(params[:id])
        rescue => e
          render json: {status: 'ERROR', message: 'Reservation not found', data: e.message}, status: :not_found
        else
          render json: {status: 'SUCCESS', message: 'Loaded reservation', data: reservation}, status: :ok
        end
      end

      def create
        begin
          vehicle = Vehicle.find(params[:vehicle])
        rescue => e
          render json: {status: 'ERROR', message: 'Vehicle not found', data: e.message}, status: :not_found
        else
          reservation = vehicle.reservations.build(reservation_params)
          customer = vehicle.customer
          reservation.customer = customer

          if reservation.save
            render json: {status: 'SUCCESS', message: 'Saved reservation', data: reservation}, status: :ok
          else
            render json: {status: 'ERROR', message: 'Reservation not saved', data: reservation.errors}, status: :unprocessable_entity
          end
        end
      end

      def destroy
        begin
          reservation = Reservation.find(params[:id])
        rescue => e
          render json: {status: 'ERROR', message: 'Reservation not found', data: e.message}, status: :not_found
        else
          if reservation.destroy
            render json: {status: 'SUCCESS', message: 'Deleted reservation', data: reservation}, status: :ok
          else
            render json: {status: 'ERROR', message: 'Reservation not deleted', data: reservation.errors}, status: :unprocessable_entity
          end
        end
      end

      def update
        begin
          reservation = Reservation.find(params[:id])
        rescue => e
          render json: {status: 'ERROR', message: 'Reservation not found', data: e.message}, status: :not_found
        else
          if reservation.update(reservation_params)
            render json: {status: 'SUCCESS', message: 'Updated reservation', data: reservation}, status: :ok
          else
            render json: {status: 'ERROR', message: 'Reservation not updated', data: reservation.errors}, status: :unprocessable_entity
          end
        end
      end

      private

      def reservation_params
        params.require(:reservation).permit(:year, :month, :day, :hour, :minute, :employee)
      end
    end
  end
end
