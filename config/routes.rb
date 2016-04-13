Rails.application.routes.draw do
  resources :words do
    post :register, on: :collection
    get :download, on: :collection
  end
end
