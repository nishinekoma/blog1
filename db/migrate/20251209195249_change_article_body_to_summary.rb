class ChangeArticleBodyToSummary < ActiveRecord::Migration[7.1]
  def change
    remove_column :articles, :body, :text

    add_column :articles, :summary, :text, null: false, default: ''
  end
end
