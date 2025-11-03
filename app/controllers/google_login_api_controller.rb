require 'open-uri'
class GoogleLoginApiController < ApplicationController
    # 画像変換
    # ダウンロードする画像を返す
    def picture_save(url)
      tempfile = Tempfile.new(['downloaded_image', '.jpg'])
      
      # URI.open
      URI.open(url) do |image|
        #画像を読み込むためバイナリモードに変換　なぜかはmemo.txt
        tempfile.binmode
        #writeで書き込み
        tempfile.write(image.read)
      end
    
      tempfile.rewind
      tempfile # 一時ファイルオブジェクトを返す
    end

    # Class: Google::Auth::IDTokens::Verifier 外部ライブラリの読み込み
    require 'googleauth/id_tokens/verifier'
  
    #Rails doc ：CSRF対策の設定 :except(除く)　	実行しないアクション
    protect_from_forgery except: [:callback, :signup_callback]
    #Rails doc: アクション前に処理を実行。　
    before_action :verify_g_csrf_token
  
    def callback
      # 発行されたAPIを確認し格納する。　
      p params[:credential]
      payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: ENV['GOOGLE_CLIENT_ID'])
      p "decoded payload is " , payload
      # find_or_create_by 引数の条件に該当するデータを見つける。
      user = User.find_or_create_by(email: payload['email'])
      # Userモデルからid を見つけログインしているユーザとして session に保存 sessions_helper
      p "user :" ,user
      log_in user
      # redirect_to で、　コントローラcontroller　→　URL　→　route　→　controller　→　view　遷移する。
      redirect_to root_path, notice: 'ログインしました'
    end
  
    #    ---- signup ----  
    def signup_callback
      p "signup_callback stated "
      #　Userのモデルオブジェクトを生成
      @user = User.new 
      #　発行されたAPIを確認し復元し格納
      payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: ENV['GOOGLE_CLIENT_ID'])
      #ランダムpassword生成
      generated_password = SecureRandom.hex(10)
      #保存した画像を取得
      picture_icon = picture_save(payload['picture'])
      # p picture_icon
      #　ユーザ作成
      @user = User.new(
        name: payload['name'], 
        email: payload['email'],
        password: generated_password,
        password_confirmation: generated_password,
        )

      #すでに登録されているemailの場合
      if User.exists?(email: @user.email)
        p "email already exists"
        redirect_to login_path, notice: 'すでに登録されています。ログインしてください'
        return
      end

      #ユーザ情報登録処理開始　sessions_helper.rb
      #user_save(@user) attach 付属させる
        if @user.save
          @user.image_icon.attach(io: picture_icon, filename: 'downloaded_image.jpg')
          log_in @user
          p  "google api user succssed" , @user
          redirect_to "/admin_decide", notice: 'Successfully to create account'
          #redirect_to root_path, notice: 'Successfully created account'
        else
          p "failed signup"
          p @user.errors.full_messages # エラー出力’
          render 'sessions/signup', status: :unprocessable_entity
      end
    end
        #    ---- private method ---- 
    #befo_action によりaction前に検証が実行される。
    private
    def verify_g_csrf_token
        # 空白であるまたは一致しない場合
      if cookies["g_csrf_token"].blank? || params[:g_csrf_token].blank? || cookies["g_csrf_token"] != params[:g_csrf_token]
        redirect_to login_path, notice: '不正なアクセスです'
        p "不正アクセス"
      end

    end
  end