class CreateCopartLotPhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :copart_lot_photos do |t|
      t.references :copart_lot, index: true, foreign_key: true, null: false
      t.string :photo

      t.timestamps
    end
  end
end
