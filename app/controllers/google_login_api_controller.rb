class GoogleLoginApiController < ApplicationController
    # Class: Google::Auth::IDTokens::Verifier 外部ライブラリの読み込み
    
    require 'googleauth/id_tokens/verifier'
  
    #Rails doc ：CSRF対策の設定 :except(除く)　	実行しないアクション
    protect_from_forgery except: :callback
    #Rails doc: アクション前に処理を実行。　
    before_action :verify_g_csrf_token
  
    def callback
      # 発行されたAPIを確認し格納する。　
      payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: ENV['GOOGLE_CLIENT_ID'])
      # find_or_create_by 引数の条件に該当するデータを見つける。
      user = User.find_or_create_by(email: payload['email'])
      # Userモデルからid を見つけログインしているユーザとして session に保存
      session[:user_id] = user.id
      # redirect_to で、　コントローラcontroller　→　URL　→　route　→　controller　→　view　遷移する。
      redirect_to root_path, notice: 'ログインしました'
    end
  
    #befo_action によりaction前に検証が実行される。
    private
    def verify_g_csrf_token
        # 空白であるまたは一致しない場合
      if cookies["g_csrf_token"].blank? || params[:g_csrf_token].blank? || cookies["g_csrf_token"] != params[:g_csrf_token]
        redirect_to login_path, notice: '不正なアクセスです'
      end
    end

    #    ---- signup ----  
    def signup_callback
        #　発行されたAPIを確認し格納
        payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: ENV['GOOGLE_CLIENT_ID'])

        #
    end

end