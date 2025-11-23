class HomeController < ApplicationController
  def index
    if logged_in?
      #もしログインしていれば、現在ログインしているUser情報を格納する
      @user = User.find(session[:user_id]) 
      #roleが１のUserを格納し、そのユーザに関するArticleをロードする
      @users = User.where(role: 1).includes(:articles)

      p "index   @users :", @users
      p "index user.article.arder(:user_id) \n" , @articles #or puts @articles

    else
      redirect_to login_url
    end

  end
end
