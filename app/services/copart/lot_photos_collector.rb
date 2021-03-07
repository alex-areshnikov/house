module Copart
  class LotPhotosCollector
    COPART_LOT_PHOTOS_COUNT = 10

    def initialize(lot_number)
      @lot_number = lot_number
    end

    def call
      copart_lot = ::Datastorage::Finder.new(:copart_lot, {"lot_number" => lot_number}).find

      return if copart_lot.nil?
      return if copart_lot.copart_lot_photos.count >= COPART_LOT_PHOTOS_COUNT

      ::Copart::NodeCommandSender.new(copart_lot).collect_lot_photos
    end

    private

    attr_reader :lot_number
  end
end
