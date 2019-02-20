Rails.application.routes.draw do

  root 'home#index'

  get  'index',           to: 'home#index'
  get  'search',          to: 'home#search'
  get  'find',            to: 'home#find'
  get  'load_data_local', to: 'home#load_data_local', as: 'load_data_local'

end
