class HomeController < ApplicationController
  def index
    if logged_in?
      #もしログインしていれば、現在ログインしているUser情報を格納する
      @user = User.find(session[:user_id]) 
      #roleが１のUserを格納し、そのユーザに関するArticleをロードする
      @users = User.where(role: 1).includes(:articles)
      # statusがpublicの記事を新しい順に並び替えて格納、関連するuser情報も一緒にロードする
      @articles_desc_public = Article.joins(:user).where(status: 'public').order(created_at: :desc).includes(:user)
      p "index   @users :", @users
      p "Article.order(created_at: :desc).includes(:user) \n" , @articles_desc_public#or puts @articles

    else
      redirect_to login_url
    end

  end
end
