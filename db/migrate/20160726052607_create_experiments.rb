class CreateExperiments < ActiveRecord::Migration
  def up
    create_table :experiments do |t|
      t.boolean :needs_adult_supervision, default: false
      t.boolean :is_active, default: false
      t.datetime :active_at
      t.string :slug

      t.timestamps null: false
    end

    add_index :experiments, :is_active
    add_index :experiments, :slug, unique: true

    Experiment.create_translation_table! title: :string, intro: :text, explanation: :text, warning: :text, slug: :string
    add_index :experiment_translations, :title
    add_index :experiment_translations, :slug

    create_join_table :categories, :experiments
  end

  def down
    drop_table :experiments
    Experiment.drop_translation_table!
    drop_join_table :categories, :experiments
  end
end
