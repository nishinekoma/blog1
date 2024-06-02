class SessionsController < ApplicationController

  def login #View login.html.erb
  end

  #ログインページから送信された情報を受け取り、ログイン処理を行う
  def create
    #Email comparison
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      log_in user
      redirect_to root_url
      p "login successed"
    else
      render 'login'
      p "login failed"
    end
  end

  #cookieに保存されたユーザーidを削除し、ログアウトを行う
  def destroy
    log_out if logged_in?
    redirect_to 'login'
  end

end
