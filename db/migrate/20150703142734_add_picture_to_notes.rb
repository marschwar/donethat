class AddPictureToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :picture, :string
  end
end
