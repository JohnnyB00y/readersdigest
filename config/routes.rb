Rails.application.routes.draw do
  
 

  root 'links#index'
  resources :tags, only: [:index, :show]

  resources :links, except: :index do
    resources :comments, only: [:create, :edit, :update, :destroy]
    post :upvote, on: :member

  end
  resources :tags, only: [:index, :show]

  get '/comments' => 'comments#index'
  	get '/newest' => 'links#newest', as: :newest_links 
devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
resources :users
end