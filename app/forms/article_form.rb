#責務　記事(Article)の内容を更新、削除、変更処理
#models dirに置かない理由は、データベースの単一テーブルに直接マッピングされるクラスではなく↓
#Article と ContentBlock という複数のテーブルのデータを扱うため、単一テーブルの原則に反するため。
#分離した二つのテーブルを使用するから必要な情報のみ集めた架空schemaのArticleFormを定義して加工を行う
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
    #Attributeが呼び出される。自動初期化ロジックが上書きされるのを防ぐためsuperで元のロジックを呼び出す
    #自動初期化ロジックは、attributesハッシュのキーと一致する属性(attribute)を探し、それらに対応する値を設定する
    super(attributes)
    # フォームの編集時（idが存在する場合）は、既存の content_blocksを設置 
    #db/schemaにArticleFormにはcontent_blocksテーブルは存在しないが、ArticleFormクラス内でcontent_blocks_attributesとして定義されている
    #content_blocks_attributesはattr_accessorで定義されているため、ArticleFormのインスタンス変数として利用可能
    #リクエストごとにcontrollerからユーザが現在いるフォームの複数のデータを受け取り、ArticleForm.newされることでpresent?を判定できる。
    if self.id.present?
      #既存の記事取得、紐づいているContentBlockも取得
      article = Article.find(self.id)
      #Article.idに紐づいている複数のContentBlockを取得し格納
      self.content_blocks_attributes = article.content_blocks.map do | block |
        # 既存のブロックをハッシュ形式でセット
        block.attributes.slice('id', 'block_type', 'content', 'image_url', 'position')
      end
    else
      #新規作成時はからのブロックリストを初期化 ||= はself.content_blocks_attributesが未定義なら[]を代入する
      self.content_blocks_attributes ||= []
    end
  end
  
  # 保存メソッド
  def save
    #バリデーションチェック
    return false unless valid?

    #
  end