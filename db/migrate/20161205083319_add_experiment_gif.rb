class AddExperimentGif < ActiveRecord::Migration
  def up
    add_attachment :experiments, :gif
    add_column :experiments, :youtube_url, :string
  end

  def down
    remove_attachment :experiments, :gif
    remove_column :experiments, :youtube_url
  end
end
