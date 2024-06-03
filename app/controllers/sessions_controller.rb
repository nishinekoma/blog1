class SessionsController < ApplicationController
# --- login function --- #
  def login #View login.html.erb
  end

  #ログインページから送信された情報を受け取り、ログイン処理を行う
  def create
    #Email comparison .downcaseでEmailの大小を無視して比較する。
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
        log_in @user
        p  "decide user ********:" , @user
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
  # --- check routes --- #
    def decide
      #現在のログイン中のユーザを格納
      @user = current_user
      p  "decide user : " , @user
    end

    def update_admin_role
      admin_password = "adminpass" #admin authenticate word

      # :admin_password : 入力されたパスワード
      if params[:admin_password] == admin_password
        @user.update_attribute(:role, 1)
        p "update user" , @user
        redirect_to root_path,  notice: '管理者に変更されました。'
      else
        flash[:notice] = "パスワードが違います。"
        p "update failed" , @user
        redirect_to admin_decide
      end
    end
end