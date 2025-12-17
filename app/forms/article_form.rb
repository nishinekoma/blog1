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
    # Attributeが呼び出される。自動初期化ロジックが上書きされるのを防ぐためsuperで元のロジックを呼び出す
    # 自動初期化ロジックは、attributesハッシュのキーと一致する属性(attribute)を探し、それらに対応する値を設定する
    super(attributes)
    # フォームの編集時（idが存在する場合）は、既存の content_blocksを設置 
    # db/schemaにArticleFormにはcontent_blocksテーブルは存在しないが、ArticleFormクラス内でcontent_blocks_attributesとして定義されている
    # content_blocks_attributesはattr_accessorで定義されているため、ArticleFormのインスタンス変数として利用可能
    # リクエストごとにcontrollerからユーザが現在いるフォームの複数のデータを受け取り、ArticleForm.newされることでpresent?を判定できる。
    if self.id.present?
      # 既存の記事取得、紐づいているContentBlockも取得
      article = Article.find(self.id)
      # Article.idに紐づいている複数のContentBlockを取得し格納
      self.content_blocks_attributes = article.content_blocks.map do | block |
        # 既存のブロックをハッシュ形式でセット
        block.attributes.slice('id', 'block_type', 'content', 'image_url', 'position')
      end
    else
      # 新規作成時はからのブロックリストを初期化 ||= はself.content_blocks_attributesが未定義なら[]を代入する
      self.content_blocks_attributes ||= []
    end
  end
  
  # Article と ContentBlock の保存処理
  def save
    # バリデーションチェック
    return false unless valid?

    # トランザクション開始
    Article.transactionon do

      # Articleの保存/更新
      # self.id が存在する場合（既存編集）は検索してインスタンスを取得し、
      # 存在しない場合（新規作成）はIDを持たない新しいインスタンスを作成。
      article = Article.find_or_initialize_by(id: self.id)
      #attributesメソッドを使用してArticleの属性をフォームの値で更新(上書き)
      article.attributes = {
        title: self.title,
        summary: self.summary,
        user_id: self.user_id
      }
      article.save!

      # ContentBlockの保存/更新/削除
      save_content_blocks(article)

      # 保存した記事インスタンスをフォームオブジェクト内に保持して返す
      @article = article
    end
    #トランザクションが成功したらtrueを返す
    true

    # エラーハンドリング（必要に応じてエラーメッセージを ArticleForm に移す処理を実装）
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      Rails.logger.error "Form saving failed: #{e.message}"
      false
  end

  # ContentBlockの保存/更新/削除処理
  def save_content_blocks(article)
    
    # ContentBlockのattributesを処理
    # positionはフォームから送信された順番に基づいて設定
    self.content_blocks_attributes.each_with_index do | block_attr, index |
      # 文字列とシンボルのどちらをキーに指定してもアクセスできるように変換　例：{ a: 1 }.with_indifferent_access["a"] # => 1　
      block_attr = block_attr.with_indifferent_access

      # ブロックが削除フラグ付きの場合かつidが存在する場合
      if block_attr[:_destroy] == '1' && block_attr[:id].present?
        # dbに保存されている既存のContentBlockを検索して削除
        content_block = article.content_blocks.find(block_attr[:id])
        content_block.destroy
        # コンテンツは削除されたため、次のループへ
        next
      end

      # ブロックの作成または更新
      # positionはループのインデックスを使用して設定
      block_attr [:position] = index

      # 既存ブロックの更新
      if block_attr[:id].present?
        # 更新したいarticleに紐づいている全てのcontent_blockレコードをidで検索して取得。idで検索するためfindを使用
        content_block = article.content_blocks.find(block_attr[:id])
        #id, _destroyキーは不要なので除外して更新
        content_block.update!(block_attr.except(:id, :_destroy)) 
      else
        # 新規ブロックの作成
        article.content_blocks.create!(block_attr.except(:_destroy))
      end

    end #end content_blocks_attributes.each_with_index
  end #end def save_content_blocks
end #end class ArticleForm