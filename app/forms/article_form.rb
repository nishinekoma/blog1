#責務　記事(Article)の内容を更新、削除、変更処理
#models dirに置かない理由は、データベースの単一テーブルに直接マッピングされるクラスではなく↓
#Article と ContentBlock という複数のテーブルのデータを扱うため、単一テーブルの原則に反するため。
class ArticleForm
  include ActiveModel::Model #model のような基本的な機能
  include ActiveModel::Attributes #フォームから受け取ったstringを型変換する
  include ActiveModel::Validations #フォーム入力チェック有効化

  # Article モデルの属性　型変換定義
  attribute :title, :string
  attribute :summary, :text
  attribute :user_id, :integer
  attribute :id, :integer

  # ContentBlock の属性を格納するための配列
  # form_with の仕様に合わせ、初期値として空の配列を定義
  attr_accessor :content_blocks_attributes

  # バリデーションルール
  validates :title, presence: true
  validates :summary, presence: true

  #初期化メソッド　引数なしで渡される場合もあるのでデフォルト値を設定
  def initialize(attributes = {})
    #既存記事の読み込み
    super(attributes)
    # フォームの編集時（idが存在する場合）は、既存の content_blocksを設置
    if self.id.present?
      article = Article.find(self.id)
      self.content_blocks_attributes = article.content_blocks.map do | block |
        # 既存のブロックをハッシュ形式でセット
        block.attributes.slice('id', 'block_type', 'content', 'image_url', 'position')
      end
    else
      #新規作成時はからのブロックリストを初期化 ||= はself.content_blocks_attributesが未定義なら[]を代入する
      self.content_blocks_attributes ||= []
    end
  end
  