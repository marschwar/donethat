class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :uid, null: false
      t.integer :trip_id, null: false
      t.string :title
      t.string :slug
      t.text :content
      t.decimal :longitude
      t.decimal :latitude
      t.string :image_uid # dragonfly
      t.integer :image_changed, length: 8 # bigint
      t.integer :note_timestamp, length: 8 # bigint
      t.timestamps
    end

    add_index :notes, :trip_id, name: "idx_notes_trip"
    add_index :notes, :slug, unique: true
  end
end
