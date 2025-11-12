class AddCropAttributesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :image_x, :integer
    add_column :users, :image_y, :integer
    add_column :users, :image_w, :integer
    add_column :users, :image_h, :integer
  end
end
