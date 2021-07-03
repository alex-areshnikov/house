module Datastorage
  module Creators
    class VehiclePhotoFolder
      ROOT = "root"

      def initialize(vehicle, parent_folder_id, folder_attributes)
        @vehicle = vehicle
        @parent_folder_id = parent_folder_id
        @folder_attributes = folder_attributes
      end

      def create
        ::Folder.create(folder_attributes.merge(owner: owner))
      end

      private

      def owner
        parent_folder_id == ROOT ? vehicle : parent_folder
      end

      def parent_folder
        @_parent_folder = ::Folder.find(parent_folder_id)
      end

      attr_reader :vehicle, :parent_folder_id, :folder_attributes
    end
  end
end
