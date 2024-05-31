Rails.application.routes.draw do
  get 'sessions/new'
  root "articles#index"
  
    resources :articles do
      resources :comments#登録されている記事などのリソースのコレクションをすべてマップ
  end

  #loginpage routes
  get    '/login',   to: 'sessions#login'
  post   '/login',   to: 'sessions#create'
  
  get '/logout', to: 'sessions#destroy'
  delete '/logout',  to: 'sessions#destroy'

end