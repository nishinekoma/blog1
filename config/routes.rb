Rails.application.routes.draw do
  root "articles#index"
  
    resources :articles do
      resources :comments#登録されている記事などのリソースのコレクションをすべてマップ
  end
end