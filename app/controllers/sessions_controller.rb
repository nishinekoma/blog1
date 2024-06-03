class SessionsController < ApplicationController
# --- login function --- #
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
      render login
      p "login failed"
    end
  end

  #cookieに保存されたユーザーidを削除し、ログアウトを行う
  def destroy
    log_out if logged_in?
    redirect_to login_path, allow_other_host: true
  end


# --- singup function --- #
  def signup #View signup.html.erb
    @user = User.new #Userのモデルオブジェクトを生成
  end

  def new
    @user = User.new(user_params)

    if @user.save
        redirect_to root_path, notice: 'Successfully created account'
      else
        p "failed signup"
        render :signup
    end
  end
  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end