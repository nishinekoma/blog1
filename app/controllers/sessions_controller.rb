class SessionsController < ApplicationController
# --- 共通layout --- #
  # newアクションとcreateアクションで auth.html.erb を使用
  layout 'auth', only: [:login ,:signup]

# --- login function --- #
  def login #View login.html.erb
  end

  #ログインページから送信された情報を受け取り、ログイン処理を行う
  def create
    #name comparison .downcaseでnameの大小を無視して比較する。 存在しなければnil
    user = User.find_by(name: params[:name].downcase)
    # userが存在する(nil)でない　かつ　パスワードが正しいか比較
    if user && user.authenticate(params[:password])
      log_in user
      redirect_to root_url
      p "login successed"
    else
      render :login,status: :unprocessable_entity
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
    #Userのモデルオブジェクトを生成
    @user = User.new 
    p @user
  end

  def new
    @user = User.new(user_params)
    
    #ユーザ情報登録処理開始　sessions_helper.rb
    user_save(@user)
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
      p "admin_check started"
      ## admin_check.html.erb を表示
      ## postで管理者判定 update_admin_role
      @user = current_user
    end

  private
    def user_params
      p "user_params is \n", params
      # ここにクロップ情報用の4つのパラメータを追加します
      params.require(:user).permit(
        :name, :email, :password, :password_confirmation, :image_icon,
        #CropperJSから送られるhidden fieldのキーを追加
        :image_x, :image_y, :image_w, :image_h
      )
    end
  end
