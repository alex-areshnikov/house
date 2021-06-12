# frozen_string_literal: true

class BackfillVehicles < ActiveRecord::Migration[6.1]
  class CopartLot < ApplicationRecord; end
  class Vehicle < ApplicationRecord; end

  def up
    CopartLot.find_each do |copart_lot|
      next if Vehicle.where(vin: copart_lot.vin).exists?

      Vehicle.create!({ name: copart_lot.name,
                        vin: copart_lot.vin,
                        year: copart_lot.year,
                        make: copart_lot.make,
                        model: copart_lot.model,
                        odometer: copart_lot.odometer })
    end
  end

  def down
    # Do nothing
  end
end
