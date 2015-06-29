class RemoveImageUids < ActiveRecord::Migration
  def change
    remove_column :notes, :image_uid
  end
end
