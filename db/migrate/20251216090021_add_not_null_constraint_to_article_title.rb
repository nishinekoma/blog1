class AddNotNullConstraintToArticleTitle < ActiveRecord::Migration[7.1]
  def change
    change_column_null :articles, :title, false
  end
end