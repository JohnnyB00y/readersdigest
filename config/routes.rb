Rails.application.routes.draw do
  
 

  get 'relationships/follow_user'

  get 'relationships/unfollow_user'

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

  post ':user_id/follow_user', to: 'relationships#follow_user', as: :follow_user
  post ':user_id/unfollow_user', to: 'relationships#unfollow_user', as: :unfollow_user

devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}
resources :users
end