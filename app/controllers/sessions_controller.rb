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

  #private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
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
        redirect_to "/admin_decide", notice: 'Successfully to create account'
        #redirect_to root_path, notice: 'Successfully created account'
      else
        p "failed signup"
        p @user.errors.full_messages # エラー出力’
        render :signup, notice: 'Failed to creat account'
    end
  end
  def update_admin_role
    p "update_admin_role colled"
    admin_password = "adminpass" #admin authenticate word
    #現在のユーザ返す
    @user = current_user
    # :admin_password : 入力されたパスワード
    if params[:admin_password] == admin_password
      p "update user" , @user
      @user.update_attribute(:role, 1)
      p "update user" , @user
      redirect_to root_path, notice: '管理者に変更されました。'
    else
      flash[:notice] = "パスワードが違います。NSSメンバーでない場合ゲストを選択してください。"
      p "update failed" , @user
      #dateの更新がないため、renderのほうがいいかも 改良
      redirect_to admin_decide_path
    end
  end
  
  # --- check routes --- #
    def decide
      # # decide.html.erb を表示
      #現在のログイン中のユーザを格納
      # @user = current_user
      p  "decide user : " , @user
    end

    def admin_check
      p "admin_check         dafafafdafsfsafsdfadfsafasdf"
      ## admin_check.html.erb を表示
      ## postでsessions_helperからメソッド呼び出し管理者判定
      if params[:admin_password] == "adminpass" # パスワードの比較
        p "update user"
        update_admin_role
      else
        p "update failed user"
        flash[:notice] = "パスワードが違います。NSSメンバーでない場合ゲストを選択してください。"
        render :admin_check
      end
    end
    # private
    #   def user_params
    #     params.require(:user).permit(:name, :email, :password, :password_confirmation)
    #   end
end