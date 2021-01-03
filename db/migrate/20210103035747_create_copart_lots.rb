class CreateCopartLots < ActiveRecord::Migration[6.1]
  def change
    create_table :copart_lots do |t|
      t.string :lot_number
      t.datetime :sale_date

      t.timestamps
    end
  end
end
