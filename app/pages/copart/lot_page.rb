module Copart
  class LotPage
    delegate :name, to: :lot

    attr_reader :lot

    def initialize(copart_lot_id)
      @copart_lot_id = copart_lot_id
    end

    def build
      @lot = ::Copart::LotDecorator.new(::CopartLot.find(copart_lot_id))
    end

    def expenses?
      false
    end

    def suppress_vehicle_actions?
      true
    end

    private

    attr_reader :copart_lot_id
  end
end
