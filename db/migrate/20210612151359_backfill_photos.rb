class Vehicle < ApplicationRecord; end
class CopartLot < ApplicationRecord; end

class Photo < ApplicationRecord
  mount_uploader :photo, ::PhotoUploader

  belongs_to :owner, polymorphic: true
end

class CopartLot < ApplicationRecord; end

class CopartLotPhoto < ApplicationRecord
  mount_uploader :photo, ::CopartVehiclePhotoUploader

  belongs_to :copart_lot
end

class BackfillPhotos < ActiveRecord::Migration[6.1]
  def up
    Photo.destroy_all

    CopartLotPhoto.find_each do |copart_lot_photo|
      vehicle = Vehicle.find_by(vin: copart_lot_photo.copart_lot&.vin)

      next if vehicle.nil?

      photo = Photo.create!({ owner: vehicle })
      photo.photo = File.open(copart_lot_photo.photo.file.file)
      photo.save!
    end
  end

  def down
    # Do nothing
  end
end
