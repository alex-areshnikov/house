module Datastorage
  module Finders
    class CopartLot
      def self.by_vehicle_id(vehicle_id)
        ::CopartLot.find_by!(vehicle_id: vehicle_id)
      end
    end
  end
end
