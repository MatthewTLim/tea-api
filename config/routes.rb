Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :customers, only: [:create] do
        resources :subscriptions, only: [:create, :index, :update]
      end
    end
  end
end
