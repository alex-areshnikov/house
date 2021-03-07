module Copart
  class LotPhotosCollector
    COPART_LOT_PHOTOS_COUNT = 10

    def initialize(copart_lot)
      @copart_lot = copart_lot
    end

    def call
      return if copart_lot.nil?
      return if copart_lot.copart_lot_photos.count >= COPART_LOT_PHOTOS_COUNT

      ::Copart::NodeCommandSender.new(copart_lot).collect_lot_photos
    end

    private

    attr_reader :copart_lot
  end
end
