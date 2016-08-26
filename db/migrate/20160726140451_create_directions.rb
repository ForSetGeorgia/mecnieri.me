class CreateDirections < ActiveRecord::Migration
  def up
    create_table :directions do |t|
      t.integer :experiment_id
      t.integer :sort_order, limit: 1, default: 1

      t.timestamps null: false
    end

    add_attachment :directions, :image
    add_index :directions, :experiment_id
    add_index :directions, :sort_order

    Direction.create_translation_table! content: :text

  end

  def down
    drop_table :directions
    Direction.drop_translation_table!
  end
end
