class CommentsController < ApplicationController
  http_basic_authenticate_with name: "dhh", password: "secret", only: :destroy
    def create
        @article = Article.find(params[:article_id]) #見ている記事を探す
        @article = @article.comments.create(comment_params) #その記事に付属するコメントを作成　
        redirect_to article_path(@article) #
    end
    
    def destroy
      @article = Article.find(params[:article_id])
      @comment = @article.comments.find(params[:id])
      @comment.destroy
      #status ActionDispathに定義されている module Statusにシンボリック定義されてる。
      redirect_to article_path(@article), status: :see_other #一部のブラウザでは元のリクエストメソッドを使用して二重にDELEAT吸うことがあるのでこのステータスをしていするらしい
    end
    
    private
      def comment_params
        params.require(:comment).permit(:commenter, :body, :status) #引数は　commenter bodyを存在することを要求。
      end
end
