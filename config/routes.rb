Rails.application.routes.draw do
  root to: "payments#index"

  resources :payments, only: :create do
    collection do
      post :success
      post :fail
    end

    member do
      put :status
      put :confirm
      delete :cancel
    end
  end
end
