class UserDecorator
  extend Forwardable
  def_delegators :@user, :image_icon, :image_x, :image_y, :image_w, :image_h, :name, :articles

  # モデルのインスタンスを保持する　インスタンス変数の値を返す
  attr_reader :user
  
  
  # 初期化メソッド 生成後自動で呼ばれる
  def initialize(user)
    @user = user
  end

  def cropped_icon(size: 100)
    return nil unless @user.image_icon.attached?
  
    if image_w.present? && image_h.present?
      
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

# 現在のuserに関連付けられた記事数を返すメソッド
  def articles_count
    # @user.articles.where(is_public: true).count
  end

end