Rails.application.routes.draw do
  
 

  root 'links#index'
  resources :tags, only: [:index, :show]

  resources :links, except: :index do
    resources :comments, only: [:create, :edit, :update, :destroy]
    post :upvote, on: :member
    resource :bookmark, module: :links
  end
  resources :tags, only: [:index, :show]

  get '/comments' => 'comments#index'
  get '/newest' => 'links#newest', as: :newest_links 

  get '/search' => 'searches#search'

devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'sessions' }
resources :users
end