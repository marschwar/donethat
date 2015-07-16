class AddNoteDateToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :note_date, :date
    remove_column :notes, :note_timestamp, :integer
  end
end
