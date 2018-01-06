class AddImageToLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :links, :image, :string
  end
end
