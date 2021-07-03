module Datastorage
  module Creators
    class VehiclePhotos
      ROOT = "root"

      def initialize(vehicle_id, owner_id, photos)
        @vehicle_id = vehicle_id
        @owner_id = owner_id
        @photos = photos
      end

      def create
        photos.each do |photo|
          owner.photos.create!(photo: photo)
        end
      end

      private

      def owner
        owner_id == ROOT ? ::Vehicle.find(vehicle_id) : ::Folder.find(owner_id)
      end

      attr_reader :vehicle_id, :owner_id, :photos
    end
  end
end
