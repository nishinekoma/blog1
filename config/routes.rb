Rails.application.routes.draw do
  root "articles#index"
  get 'sessions/new'
  
    resources :articles do
      resources :comments#登録されている記事などのリソースのコレクションをすべてマップ
  end

  #loginpage routes
  get    '/login',   to: 'sessions#login' #request http://localhost:3000/login to sessions_controller  def login
  post   '/login',   to: 'sessions#create'

  get '/logout', to: 'sessions#destroy'
  delete '/logout',  to: 'sessions#destroy'

  #signup routes
  get '/signup', to: 'sessions#signup'
  post '/signup', to: 'sessions#new'

  # #select routes
  # get '/admin_decide', to: 'sessions#decide'
  # post '/admin_decide', to: 'sessions#'

  # #admin check routes
  # get '/admin_check', to: 'sessions#'
  # post '/admin_check', to: 'sessions#'
end