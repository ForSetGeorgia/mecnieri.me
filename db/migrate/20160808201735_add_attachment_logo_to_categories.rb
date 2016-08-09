class AddAttachmentLogoToCategories < ActiveRecord::Migration
  def self.up
    change_table :categories do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :categories, :logo
  end
end
