Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :customers

      resources :vehicles
      get '/vehicles/customer/:customer' => 'vehicles#vehicles_for_customer'

      resources :reservations
      get '/reservations/customer/:customer' => 'reservations#reservations_for_customer'
      get '/reservations/vehicle/:vehicle' => 'reservations#reservations_for_vehicle'
  end
  end
end
