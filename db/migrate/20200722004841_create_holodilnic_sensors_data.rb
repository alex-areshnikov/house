class CreateHolodilnicSensorsData < ActiveRecord::Migration[6.0]
  def change
    create_table :holodilnic_sensors_data do |t|
      t.decimal :humidity_top
      t.decimal :temperature_top_c
      t.decimal :humidity_bottom
      t.decimal :temperature_bottom_c

      t.timestamps
    end
  end
end
