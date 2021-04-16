Rails.application.routes.draw do
  get "/", to: "home#index"
  root "home#index"

  resources :spms
  resources :patients

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
