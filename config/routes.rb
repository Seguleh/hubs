Rails.application.routes.draw do

  root 'home#index'

  get  'index',               to: 'home#index'
  get  'search',              to: 'home#search'
  get  'find',                to: 'home#find'
  get  'load_data_local',     to: 'home#load_data_local',     as: 'load_data_local'
  get  'load_data_external',  to: 'home#load_data_external',  as: 'load_data_external'
  get  'find_nearest',        to: 'home#find_nearest',        as: 'find_nearest'

end
