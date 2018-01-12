class AddAuthorToLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :links, :author, :string
  end
end
