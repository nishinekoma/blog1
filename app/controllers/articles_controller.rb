class ArticlesController < ApplicationController
  def index
    @articles = Article.all #Articleというモデル名　インスタンス変数＠articlesに代入
    p @articles #or puts @articles
  end

  def show
    @article = Article.find(params[:id])
  end
  def new
    @article = Article.new
  end

  def create
    @article = Article.new(title: "...", body: "...")

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity #エラー時のメッセージ　clientが送信したリクエスト処理できないトキイに使用されえる。

    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :body)
    end
end
