module SessionsHelper
# --- login function --- #
 # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if session[:user_id]
     #@current_user = @current_user || User.find_by(id: session[:user_id])と同じ意味
      @current_user ||= User.find_by(id: session[:user_id])
      p "currnet_user", @current_user
    end
  end

  #受け取ったユーザーがログイン中のユーザーと一致すればtrueを返す
  def current_user?(user)
    user == current_user
  end

   # ユーザーがログインしていればtrue、その他ならfalseを返す
   def logged_in?
    !current_user.nil?
   end

    # 現在のユーザーをログアウトする
  def log_out
    #ブラウザのcookieに保存されているユーザーidを削除
    session.delete(:user_id)
    @current_user = nil
  end

# --- singup function --- #
  #渡されたuserの登録処理を開始する。　registration process　登録処理
  def user_save(user)
    #DBに登録開始
    if @user.save
      p "Success user.save"
      #user_idを格納してsession情報を登録
      log_in @user
      #メッセージを表示
      flash[:notice] = "Successfully to create account"
      p  "User information :" , @user
      redirect_to "/admin_decide"
      #redirect_to root_path, notice: 'Successfully created account'
    else
      p "failed user.save"
      p @user.errors.full_messages # [debug] エラー出力
      render 'sessions/signup', status: :unprocessable_entity
    end
  end

end