module Vehicles
  module Folders
    class SelectorsPage
      delegate :name, to: :vehicle, prefix: true

      attr_reader :vehicle_id, :action_code

      def initialize(vehicle_id, action_code)
        @vehicle_id = vehicle_id
        @action_code = action_code
      end

      def folders(collected_folders = [root_folder], owner = vehicle)
        owner.folders.each do |folder|
          collected_folders << build_folder(folder)
          collected_folders = folders(collected_folders, folder)
        end

        collected_folders
      end

      private

      def vehicle
        @_vehicle = ::Vehicle.find(vehicle_id)
      end

      def root_folder
        {
          id: "root",
          name: "Root"
        }
      end

      def build_folder(folder)
        {
          id: folder.id,
          name: folder.name
        }
      end
    end
  end
end
