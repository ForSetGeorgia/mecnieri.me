class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.boolean :is_active, default: true
      t.string :slug

      t.timestamps null: false
    end

    add_index :categories, :is_active
    add_index :categories, :slug, unique: true

    Category.create_translation_table! title: :string, description: :text, slug: :string
    add_index :category_translations, :title
    add_index :category_translations, :slug
  end

  def down
    drop_table :categories
    Category.drop_translation_table!
  end

end
