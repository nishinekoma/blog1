class ArticlesController < ApplicationController

  def show
    @article = Article.find(params[:id])
  end

  def new
    # 新規記事を作成している　post
    @article = ArticleForm.new(user_id: session[:user_id])
  end

  def create
    #現在ログインしているuser_idを格納????
    form_params_with_user = article_form_params.merge(user_id: session[:user_id])
    # 送信されたフォームデータを基にArticleFormオブジェクトを初期化
    @article_form = ArticleForm.new(form_params_with_user)
    p "create @article_form :",@article_form

    #ArticleFormのsaveメソッドを呼び出し、ArticleとContentBlockの保存処理を実行
    if @article_form.save
      # 保存成功時、作成された記事のIDを取得してリダイレクト
      # フォームオブジェクトが保存した記事のIDを知る必要がある（例：ArticleFormにarticleを格納する）
      # ここでは ArticleForm#save が成功したら、そのインスタンスに保存された記事情報（IDなど）があることを前提とする
      redirect_to @article_form.article
    else
      p "article form failed", @article_form.errors.full_messages
      # エラー時は :new テンプレートを再描画
      render :new, status: :unprocessable_entity
    end


    # p "session[:user_id]    :",session[:user_id]
    # #現在ログインしているuser_idを格納
    # @user_id = User.find(session[:user_id])
    # p "create @article user.find(params[:user_id]) :",@user_id
    # #そのユーザに付属する記事を作成
    # #@article = @user_id.Article.new(article_params)
    # @article = @user_id.articles.new(article_params)
    # p "@article.Article.new(article_params) :",@article
    # if @article.save
    #   redirect_to @article
    # else
    #   p "article failed",@article.errors.full_messages

    #   render :new, status: :unprocessable_entity #エラー時のメッセージ　clientが送信したリクエスト処理できないトキイに使用されえる。
    # end

  end

  # 記事編集
  def edit
    # 既存の記事IDを基にArticleFormオブジェクトを初期化
    # ArticleFormのinitialize内で、既存の記事とContentBlockを取得する
    @article = ArticleForm.new(id: params[:id]) #既存のユーザを参照している　patch
  end

  # 記事更新
  def update
    # 既存の記事IDと送信されたパラメータを組み合わせてフォームオブジェクトを初期化
    form_params_with_id = article_form_params.merge(user_id: session[:user_id])

    @article_form = ArticleForm.new(form_params_with_id)
    p "update @article_form:", @article_form

    #フォームオブジェクトのsaveメソッドを呼び出し
    if @article_form.save
      # 保存成功後、更新された記事ページへリダイレクト
      # ArticleFormに保存した記事のIDがあることを前提とする
      redirect_to @article_form.article
    else
      # エラー時は :edit テンプレートを再描画
      render :edit, status: :unprocessable_entity
    end
    # @article = Article.find(params[:id])#DBから再取得　既存のユーザを参照している　patch
    # p "#{params[:id]}      #{article_params}"
    # if @article.update(article_params)
    #   redirect_to @article
    # else
    #   render :edit, status: :unprocessable_entity
    # end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end
  
  private #ArticlesControllerのみで使用可能にし、外部からのアクセスをなくす。
    def article_form_params
      params.require(:article).permit(
        :id,
        :title,
        :summary,
        # ContentBlockのネストされた属性を受け取る
        content_blocks_attributes: [:id, :block_type, :content, :image_url, :position, :_destroy]
      )
    end
end

