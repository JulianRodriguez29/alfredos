Rails.application.routes.draw do
  namespace :authentication, path: '', as: '' do
    resources :users, only: [:new, :create], path: '/register', path_name: { new: '/'}
    resources :sessions, only: [:new, :create, :destroy], path: '/login', path_name: { new: '/'}
  end

  resources :favorites, only: :create
  resources :users, only: :show, path: '/user', param: :username
  resources :categories, except: :show
  resources :products, path: '/'
end
