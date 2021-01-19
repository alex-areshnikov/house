module Copart
  class ScanLotJob < ApplicationJob
    queue_as :default

    def perform(lot_number)
      ::Copart::ScannerExecutor.new(lot_number).call
    end
  end
end
