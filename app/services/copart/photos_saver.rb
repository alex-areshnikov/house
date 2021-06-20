module Copart
  class PhotosSaver
    def initialize(lot_number, photo_urls)
      @lot_number = lot_number
      @photo_urls = photo_urls
    end

    def call
      vehicle = ::Datastorage::Finder.new(:copart_lot_vehicle, {"lot_number" => lot_number}).find
      return if vehicle.blank?

      ::Datastorage::Destroyer.new(:photos).destroy(vehicle)

      photo_urls.each do |photo_url|
        ::Datastorage::Creator.new(:photo, { owner: vehicle, remote_photo_url: photo_url }).create
      end
    end

    private

    attr_reader :lot_number, :photo_urls
  end
end
