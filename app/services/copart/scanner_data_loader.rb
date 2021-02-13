module Copart
  class ScannerDataLoader
    def initialize(data)
      @data = data["data"]
    end

    def call
      parsed_vehicle_name = ::Copart::VehicleNameParser.new(data["name"]).call
      data["year"] = parsed_vehicle_name.year
      data["make"] = parsed_vehicle_name.make
      data["model"] = parsed_vehicle_name.model

      photo_urls = data.delete("photo_urls")

      ::Datastorage::Updater.new(:copart_lot, data).update_or_create
      ::Copart::PhotosSaver.new(data["lot_number"], photo_urls).call if photo_urls.present?
    end

    private

    attr_reader :data
  end
end
