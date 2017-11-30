Rails.application.routes.draw do
  get 'chatwindow/index'

  mount ActionCable.server => '/cable'
  
  resources :comments
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
