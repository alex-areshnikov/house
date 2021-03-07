module Copart
  module Resolvers
    class ScannerDataLoader
      def initialize(data)
        @data = data["data"]
      end

      def call
        copart_lot.scan_start! if scan_start?
        copart_lot.error! if error?
        store_scan_result if !error? && !scan_start?
      end

      private

      attr_reader :data

      def scan_start?
        data["scan_start"].present?
      end

      def error?
        data["error"].present?
      end

      def store_scan_result
        parsed_vehicle_name = ::Copart::VehicleNameParser.new(data["name"]).call
        data["year"] = parsed_vehicle_name.year
        data["make"] = parsed_vehicle_name.make
        data["model"] = parsed_vehicle_name.model

        ::Datastorage::Updater.new(:copart_lot, data).update_or_create
        ::Copart::LotPhotosCollector.new(copart_lot).call

        copart_lot.scan_complete! if copart_lot.present?
      end

      def copart_lot
        @_copart_lot ||= ::Datastorage::Finder.new(:copart_lot, data).find
      end
    end
  end
end
