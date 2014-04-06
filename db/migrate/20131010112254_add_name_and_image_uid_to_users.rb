class AddNameAndImageUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :avatar_uid, :string
  end
end
