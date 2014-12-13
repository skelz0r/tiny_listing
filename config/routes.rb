TinyListing::Application.routes.draw do
  root 'welcome#index'
  
  devise_for :users, skip: [:registrations, :sessions]

  get '/signin' => 'welcome#index', as: :user_session

  devise_scope :user do
    post 'signin' => 'devise/sessions#create'
    delete 'signout' => 'devise/sessions#destroy'
  end

  get '/search' => "search#new", as: :search
  post '/search' => "search#create"

  resources :repositories, only: [:index, :new, :create, :show, :update]
end
