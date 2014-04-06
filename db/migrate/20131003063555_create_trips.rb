class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :uid, null: false
      t.integer :user_id, null: false
      t.boolean :public, null: false, default: true
      t.string :title, null:false
      t.string :slug
      t.text :content
      t.timestamps
    end

    add_index :trips, :user_id, name: "idx_trips_user"
    add_index :trips, :slug, unique: true
  end
end
