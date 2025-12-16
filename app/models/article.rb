class Article < ApplicationRecord
  include Visible
  #  --- article dependencies --- #
    #複数の記事に対して、一つのuserを持つ
    belongs_to :user

    #一つの記事に対して複数のcommentsをもつ dependent: :destroy 削除される場合関連オブジェクト　commentsの削除
    has_many :comments, dependent: :destroy
    #一つの記事に対して複数のcontent_blockを持つ
    has_many :content_blocks, dependent: :destroy

    validates :title, presence: true ,length: { minimum: 5 }#validatesにより登録時にこれらの情報がある必要がる。https://guides.rubyonrails.org/active_record_validations.html
    validates :summary, presence: true
  end