class User < ApplicationRecord
    #secure 安全な
    has_secure_password

    #validation format for Email
    VALID_EMAIL_REGEX_C = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    validates :email, presence: true,#presence 存在確認
               uniqueness: { case_sensitive: false },#独自性　Eとeが同じで大小関係なくチェック
               length: { maximum: 105 },
               format: { with: VALID_EMAIL_REGEX_C }#正規表現があってるかチェック

    #roleを定義
    enum role: {general: 0, admin:1, top_admin:2}
end
# has_secure_password　public_method doc:https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
# User.create!(name: "あどみん",email: "admin@admin.com",password: "admin",password_confirmation: "admin",role: 1)
