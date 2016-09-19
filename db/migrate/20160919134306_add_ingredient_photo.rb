class AddIngredientPhoto < ActiveRecord::Migration
  def up
    add_attachment :experiments, :ingredient_image
  end

  def down
    remove_attachment :experiments, :ingredient_image
  end
end
