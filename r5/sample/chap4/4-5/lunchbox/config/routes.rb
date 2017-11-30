Rails.application.routes.draw do
  get 'workmenu/index', as: :workmenu

  resources :orders
  resources :members
  resources :boxes
  
  root 'workmenu#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
