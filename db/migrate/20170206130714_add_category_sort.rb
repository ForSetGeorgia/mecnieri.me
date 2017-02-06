class AddCategorySort < ActiveRecord::Migration
  def up
    add_column :categories, :sort_order, :integer, default: 1
    add_index :categories, :sort_order 

    Category.sorted.each_with_index{|x, i|
      x.sort_order = i+1
      x.save
    }
  end

  def down
    remove_index :categories, :sort_order 
    remove_column :categories, :sort_order
  end

end
