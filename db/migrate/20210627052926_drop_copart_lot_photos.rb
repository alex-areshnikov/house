class DropCopartLotPhotos < ActiveRecord::Migration[6.1]
  def change
    drop_table :copart_lot_photos
  end
end
