class ApplicationController < ActionController::Base
    #作成したヘルパーメソッドを全てのページで使えるようにする
    include SessionsHelper

    private
   # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        #ログインしていなければログインページにリダイレクトする。
        redirect_to login_url
      end
    end
end

#application_controllerに追加することで、全てのコントローラーで利用できるようになる
