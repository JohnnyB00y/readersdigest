Rails.application.routes.draw do
  

  root 'links#index'

  resources :links, except: :index do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end

  get '/comments' => 'comments#index'

devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
resources :users
end