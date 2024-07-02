class ArticlesController < ApplicationController
  def index
    #@articles = Article.all #Articleというモデル名　インスタンス変数＠articlesに代入
    #articles　に、　usre_idの昇順にしたUserに関連するArticleを渡す。 original.logic
    # @articles = Article.order(:user_id)
    # 
    @users = User.where(role: 1).includes(:articles)
    p @users

    p "index user.article.arder(:user_id) \n" , @articles #or puts @articles
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new #新規記事を作成している　post
  end

  def create
    p "session[:user_id]    :",session[:user_id]
    #現在ログインしているuser_idを格納
    @user_id = User.find(session[:user_id])
    p "create @article user.find(params[:user_id]) :",@user_id
    #そのユーザに付属する記事を作成
    #@article = @user_id.Article.new(article_params)
    @article = @user_id.articles.new(article_params)
    p "@article.Article.new(article_params) :",@article
    if @article.save
      redirect_to @article
    else
      p "article failed",@article.errors.full_messages

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
      params.require(:article).permit(:title, :body, :status)
    end
end

