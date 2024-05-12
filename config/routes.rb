Rails.application.routes.draw do
  root "articles#index"

  resources :articles#登録されている記事などのリソースのコレクションをすべてマップ
end
