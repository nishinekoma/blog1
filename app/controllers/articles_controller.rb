class ArticlesController < ApplicationController
  def index
    @articles = Article.all #Articleというモデル名　インスタンス変数＠articlesに代入
    p @articles #or puts @articles
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new #新規ユーザを作成している　post
  end

  def create
    @article = Article.new(article_params)#新規ユーザを作成している　post

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity #エラー時のメッセージ　clientが送信したリクエスト処理できないトキイに使用されえる。

    end
  end

  def edit #DBから記事を取得 @articleに保存
    @article = Article.find(params[:id]) #既存のユーザを参照している　patch
  end

  def update
    @article = Article.find(params[:id])#DBから再取得　既存のユーザを参照している　patch
    p "#{params[:id]}      #{article_params}"
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end
  

  private #ArticlesControllerのみで使用可能にし、外部からのアクセスをなくす。
    def article_params
      params.require(:article).permit(:title, :body)
    end
end

