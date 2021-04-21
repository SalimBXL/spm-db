Rails.application.routes.draw do
  get "/", to: "home#index"
  root "home#index"

  get "/matlab", to: "matlab#index"
  get "/start_matlab", to: "matlab#start_matlab"


  resources :spms
  resources :patients
  resources :settings

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
