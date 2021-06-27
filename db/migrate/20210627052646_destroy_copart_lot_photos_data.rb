class CopartLotPhoto < ApplicationRecord
  mount_uploader :photo, ::CopartVehiclePhotoUploader
end

class DestroyCopartLotPhotosData < ActiveRecord::Migration[6.1]
  def change
    ::CopartLotPhoto.destroy_all
  end
end
