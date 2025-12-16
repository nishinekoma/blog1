class CreateContentBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :content_blocks do |t|
      t.references :article, null: false, foreign_key: true
      t.string :block_type
      t.text :content
      t.string :image_url
      t.integer :position

      t.timestamps
    end
  end
end
