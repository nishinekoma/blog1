class User < ApplicationRecord
  #  --- user dependencies --- #
    # article
    has_many :articles, dependent: :destroy
    # image one icon Active Strageでファイル紐づけ宣言
    has_one_attached :image_icon
  #  --- user  validations --- #
    #secure 安全な
    has_secure_password validations: false

    #validation format for Email
    VALID_EMAIL_REGEX_C = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    # validations messages
    # signup
    validates  :name, presence: {message: "Nameは空白不可です。"},
               uniqueness: {case_sensitive: false,message: "このNameは既に使われています。"}
    validates  :email, presence: {message: "Emailは空白不可です。"},#presence 存在確認
               uniqueness: { case_sensitive: false ,message: "このEmailは既に使われています。"} ,#独自性　Eとeが同じで大小関係なくチェック
               length: { maximum: 105 , meaage: "105未満にしてください。"},
               format: { with: VALID_EMAIL_REGEX_C ,message: "Emailを正しい形式にしてください。"}#正規表現があってるかチェック
    validates :password, presence: { message: "パスワードを入力してください。"}
    validate :passwords_match

    #admin_check
    #roleを定義
    enum role: {general: 0, admin:1, top_admin:2}

  def cropped_icon(size: 100)
    return nil unless image_icon.attached?
  
    if image_w.present? && image_h.present?
      
      # 🌟 最終修正ポイント: resize_to_fillの前にクロップ処理を定義 🌟
      # crop: [x, y, w, h] の配列形式を ImageProcessing が解釈できるようにする
      
      # 座標とサイズを配列として定義
      crop_area = [image_x.to_i, image_y.to_i, image_w.to_i, image_h.to_i]
    
      # ImageProcessingの variant は、配列形式の crop 引数を受け付けます。
      # 最初にクロップ処理を行い、その結果に対して resize_to_fill を実行させます。
      image_icon.variant(
        crop: crop_area, # [left, top, width, height]
        resize_to_fill: [size, size]
      ).processed
      
    else
      # クロップ情報がない場合：単にリサイズ（正方形）
      image_icon.variant(
        resize_to_fill: [size, size]
      ).processed
    end
  end

    #確認用パスワードと一致しているか検査しerrors message追加。
    private
      def passwords_match
        if password != password_confirmation
          errors.add(:password_confirmation, "確認用パスワードが一致しません。")
        end
      end
end

# has_secure_password　public_method doc:https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
