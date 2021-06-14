# frozen_string_literal: true

class CreateVehicles < ActiveRecord::Migration[6.1]
  def change
    create_table :vehicles do |t|
      t.string :name
      t.string :vin
      t.integer :year
      t.string :make
      t.string :model
      t.string :engine_type
      t.integer :odometer

      t.timestamps
    end
  end
end
