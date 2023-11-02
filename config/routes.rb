Rails.application.routes.draw do
  resources :customers, only: [:create] do
    resources :subscriptions, only: [:create, :index, :destroy]
  end
end
