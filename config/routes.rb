Rails.application.routes.draw do
  root to: "payments#index"

  resources :payments, only: :create do
    collection do
      post :success
      post :fail
    end

    member do
      put :status
      delete :cancel
    end
  end
end
