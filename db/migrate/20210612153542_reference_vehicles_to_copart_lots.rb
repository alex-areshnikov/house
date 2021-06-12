class ReferenceVehiclesToCopartLots < ActiveRecord::Migration[6.1]
  def change
    add_reference :copart_lots, :vehicle, foreign_key: true
  end
end
