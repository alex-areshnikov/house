class CopartLotPhoto < ApplicationRecord
  mount_uploader :photo, ::CopartVehiclePhotoUploader

  belongs_to :copart_lot
end
