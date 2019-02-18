Rails.application.routes.draw do
  root 'home#index'
  get  'index',     to: 'home#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
