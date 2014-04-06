class ChangePrecisionOfLocation < ActiveRecord::Migration
  def self.up
    change_column :notes, :latitude, :decimal, :precision => 15, :scale => 10
    change_column :notes, :longitude, :decimal, :precision => 15, :scale => 10
  end
end
