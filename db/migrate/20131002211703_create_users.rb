class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :type, null: false
      t.string :identifier, null: false
      t.string :secret
      t.timestamps
    end
  end
end
