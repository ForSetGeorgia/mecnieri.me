class AddColor < ActiveRecord::Migration
  def change
    add_column :categories, :color_hex, :string
  end
end
