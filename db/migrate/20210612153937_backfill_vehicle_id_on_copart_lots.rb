class CopartLot < ApplicationRecord
  self.ignored_columns = %w()
end

class Vehicle < ApplicationRecord; end

class BackfillVehicleIdOnCopartLots < ActiveRecord::Migration[6.1]
  def up
    CopartLot.find_each do |copart_lot|
      vehicle = Vehicle.find_by(vin: copart_lot.vin)

      next if vehicle.nil?

      copart_lot.vehicle_id = vehicle.id
      copart_lot.save!
    end
  end

  def down
    # Do nothing
  end
end
