class AddVehicleAttrsToCopartLot < ActiveRecord::Migration[6.1]
  def change
    add_column :copart_lots, :name, :string
    add_column :copart_lots, :vin, :string
    add_column :copart_lots, :primary_damage, :string
    add_column :copart_lots, :secondary_damage, :string
  end
end
