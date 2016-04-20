Rails.application.routes.draw do
  resources :words do
    get :new_by_urls, on: :collection
    post :register_by_urls, on: :collection
    get :download, on: :collection
  end

  namespace :api do
    resources :words, only: :destroy
    resources :related_words, only: :create
  end
end
