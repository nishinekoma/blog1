Rails.application.routes.draw do
  root "articles#index"
  get 'sessions/new'
  
    resources :articles do
      resources :comments#登録されている記事などのリソースのコレクションをすべてマップ
  end



  #loginpage routes
  get    '/login',   to: 'sessions#login' #request http://localhost:3000/login to sessions_controller  def login
  post   '/login',   to: 'sessions#create'

  get    '/logout',  to: 'sessions#destroy'
  delete '/logout',  to: 'sessions#destroy'

  #google API login and signup
  post '/google_login_api/callback', to: 'google_login_api#callback'
  post '/google_login_api/signup_callback', to: 'google_login_api#signup_callback'

  
  #signup routes
  get    '/signup', to: 'sessions#signup'
  post   '/signup', to: 'sessions#new'

  #select routes
  get  '/admin_decide', to: 'sessions#decide'
  # 受け取るだけなので多分POSTはいらない？
  post '/admin_decide', to: 'sessions#decide'

  #admin check routes
  get     '/admin_check', to: 'sessions#admin_check'
  post    '/admin_check', to: 'sessions#update_admin_role'
end