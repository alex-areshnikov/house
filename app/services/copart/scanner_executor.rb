module Copart
  class ScannerExecutor
    def initialize(lot_number)
      @lot_number = lot_number
    end

    def call
      `yarn scan_lot #{lot_number}`
    end

    private

    attr_reader :lot_number
  end
end
