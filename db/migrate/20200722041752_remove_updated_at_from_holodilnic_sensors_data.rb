class RemoveUpdatedAtFromHolodilnicSensorsData < ActiveRecord::Migration[6.0]
  def change
    remove_column :holodilnic_sensors_data, :updated_at
  end
end
