class ChangeDirnImg < ActiveRecord::Migration
  def up
    drop_table :direction_images
    add_attachment :directions, :image    
  end

  def down
    create_table :direction_images do |t|
      t.integer :direction_id
      t.integer :sort_order, limit: 1, default: 1

      t.timestamps null: false
    end

    add_attachment :direction_images, :image
    add_index :direction_images, :sort_order
    add_index :direction_images, :direction_id

    remove_attachment :directions, :image
  end
end
