module Copart
  module Resolvers
    class ScannerDataLoader
      def initialize(data)
        @data = data["data"]
      end

      def call
        parsed_vehicle_name = ::Copart::VehicleNameParser.new(data["name"]).call
        data["year"] = parsed_vehicle_name.year
        data["make"] = parsed_vehicle_name.make
        data["model"] = parsed_vehicle_name.model

        ::Datastorage::Updater.new(:copart_lot, data).update_or_create
        ::Copart::LotPhotosCollector.new(data["lot_number"]).call
      end

      private

      attr_reader :data
    end
  end
end
