class RemoveCatFields < ActiveRecord::Migration
  def up
    remove_attachment :categories, :logo
    remove_column :categories, :color_hex
  end

  def down
    change_table :categories do |t|
      t.attachment :logo
    end
    add_column :categories, :color_hex, :string
  end
end
