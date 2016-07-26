class AddExperimentThumbs < ActiveRecord::Migration
  def up
    add_attachment :experiments, :thumbnail1
    add_attachment :experiments, :thumbnail2
  end

  def down
    remove_attachment :experiments, :thumbnail1
    remove_attachment :experiments, :thumbnail2
  end
end
