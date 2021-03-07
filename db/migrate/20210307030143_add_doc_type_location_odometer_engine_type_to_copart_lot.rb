class AddDocTypeLocationOdometerEngineTypeToCopartLot < ActiveRecord::Migration[6.1]
  def change
    add_column :copart_lots, :doc_type, :string
    add_column :copart_lots, :odometer, :string
    add_column :copart_lots, :engine_type, :string
    add_column :copart_lots, :location, :string
  end
end
