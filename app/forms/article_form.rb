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
  attribute :summary, :string
  attribute :user_id, :integer
  attribute :id, :integer
  attribute :status, :string, default: 'public'

  # 保存した記事インスタンスを保持するための属性
  attr_reader :article

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
    if self.id.present? && self.content_blocks_attributes.blank?
      article = Article.find(self.id)
      self.content_blocks_attributes = article.content_blocks.map do | block |
        block.attributes.slice('id', 'block_type', 'content', 'image_url', 'position')
      end
    else
        # 新規作成時かつデータが空の場合のみ空配列をセット
        self.content_blocks_attributes ||= []
    end
  end
  
  # Article と ContentBlock の保存処理
  def save
    # バリデーションチェック
    return false unless valid?

    # トランザクション開始
    Article.transaction do

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

  def content_blocks_attributes=(attributes)
    @content_blocks_attributes = attributes
  end

  # ContentBlockの保存/更新/削除処理
  def save_content_blocks(article)
    # content_blocks_attributes が空なら何もしない
    return if content_blocks_attributes.blank?

    # Railsのフォームからハッシュ形式 {"0"=>{...}, "1"=>{...}} で届くため、
    # その「値」の部分だけを配列として取り出す
    attributes_array = if content_blocks_attributes.is_a?(Hash)
                         content_blocks_attributes.values
                       else
                         content_blocks_attributes
                       end

    attributes_array.each_with_index do |block_attr, index|
      # block_attr をシンボルでもアクセスできるように変換
      b = block_attr.with_indifferent_access

      # 削除処理
      if b[:_destroy] == '1'
        article.content_blocks.find(b[:id]).destroy if b[:id].present?
        next
      end

      # 保存するパラメータの整理（contentやblock_typeがさらにハッシュになっていないか確認）
      # View側の不具合（例の ] 問題）でハッシュになっている場合にも対応できる書き方
      save_params = {
        block_type: b[:block_type].is_a?(Hash) ? b[:block_type].values.first : b[:block_type],
        content:    b[:content].is_a?(Hash) ? b[:content].values.first : b[:content],
        position:   index # 送信された順番を保持
      }

      if b[:id].present?
        # 既存ブロックの更新
        article.content_blocks.find(b[:id]).update!(save_params)
      else
        # 新規ブロックの作成
        article.content_blocks.create!(save_params)
      end
    end
  end
end #end class ArticleForm