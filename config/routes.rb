Rails.application.routes.draw do
  resources :customers, only: [:create, :show, :update, :destroy] do
    resources :subscriptions, only: [:create, :index, :destroy]
  end
end
