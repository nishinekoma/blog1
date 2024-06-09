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

  # #private
  #   def user_params
  #     params.require(:user).permit(:name, :email, :password, :password_confirmation)
  #   end
# --- singup function --- #
  def signup #View signup.html.erb
    @user = User.new #Userのモデルオブジェクトを生成
  end

  def new
    @user = User.new(user_params)

    if @user.save
        log_in @user
        p  "decide user ********:" , @user
        redirect_to "/admin_decide", notice: 'Successfully to create account'
        #redirect_to root_path, notice: 'Successfully created account'
      else
        p "failed signup"
        p @user.errors.full_messages # エラー出力’
        render :signup, status: :unprocessable_entity
    end
  end

  def update_admin_role
    p "update_admin_role colled"
    admin_password = ENV['ADMIN_PASSWORD'] #admin authenticate word
    #現在のユーザ返す
    @user = current_user
    # :admin_password : 入力されたパスワード
    if params[:admin_password] == ENV['ADMIN_PASSWORD']
      p "update user" , @user
      @user.update_attribute(:role, 1)
      p "update user" , @user
      redirect_to root_path, notice: '管理者に変更されました。'
    else
      p "update failed" , @user
      #エラーメッセージ表示
      @user = current_user
      @user.errors.add(:admin_password, "パスワードが一致しません。<br>NSSメンバーでない方はregularからログインしてください。")
      render :admin_check , status: :unprocessable_entity
    end
  end
  
  # --- check routes --- #
    def decide
      # decide.html.erb を表示
      # 現在のログイン中のユーザを格納
      # @user = current_user debug
      p  "decide user : " , @user
    end

    def admin_check
      p "admin_check         dafafafdafsfsafsdfadfsafasdf"
      ## admin_check.html.erb を表示
      ## postで管理者判定 update_admin_role
      @user = current_user
    end

    private
      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
end