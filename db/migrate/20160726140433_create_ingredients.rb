class CreateIngredients < ActiveRecord::Migration
  def up
    create_table :ingredients do |t|
      t.integer :experiment_id
      t.integer :sort_order, limit: 1, default: 1

      t.timestamps null: false
    end

    add_index :ingredients, :sort_order

    Ingredient.create_translation_table! content: :string

  end

  def down
    drop_table :ingredients
    Ingredient.drop_translation_table!
  end
end
