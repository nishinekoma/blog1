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

end