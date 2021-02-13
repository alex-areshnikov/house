class AddYearMakeModelToCopartLot < ActiveRecord::Migration[6.1]
  def change
    add_column :copart_lots, :year, :integer
    add_column :copart_lots, :make, :string
    add_column :copart_lots, :model, :string
  end
end
