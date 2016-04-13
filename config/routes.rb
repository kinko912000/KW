Rails.application.routes.draw do
  resources :words do
    post :register, on: :collection
  end
end
