class User < ApplicationRecord
    #secure 安全な
    has_secure_password validations: false

    #validation format for Email
    VALID_EMAIL_REGEX_C = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    # validations messages
    # signup
    validates  :name, presence: {message: "Nameは空白不可です。"}
    validates  :email, presence: {message: "Emailは空白不可です。"},#presence 存在確認
               uniqueness: { case_sensitive: false ,message: "このEmailは既に使われています。"} ,#独自性　Eとeが同じで大小関係なくチェック
               length: { maximum: 105 , meaage: "105未満にしてください。"},
               format: { with: VALID_EMAIL_REGEX_C ,message: "Emailを正しい形式にしてください。"}#正規表現があってるかチェック
    validates :password, presence: { message: "パスワードを入力してください。"}
    validate :passwords_match 

    #admin_check
    #"パスワードが一致しません。<br> NSSメンバーでない方はregularからログインしてください。")
    #roleを定義
    enum role: {general: 0, admin:1, top_admin:2}

    #確認用パスワードと一致しているか検査しerrors message追加。
    private
      def passwords_match
        if password != password_confirmation
          errors.add(:password_confirmation, "確認用パスワードが一致しません。")
        end
      end

end
# has_secure_password　public_method doc:https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
# User.create!(name: "あどみん",email: "admin@admin.com",password: "admin",password_confirmation: "admin",role: 1)
