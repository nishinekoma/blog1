class SessionsController < ApplicationController

  def login
  end

  #ログインページから送信された情報を受け取り、ログイン処理を行う
  def create
    #mail
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
      p "aaaa"
    else
      flash[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new'
      p "bbbbbb"
    end
  end

  #cookieに保存されたユーザーidを削除し、ログアウトを行う
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
