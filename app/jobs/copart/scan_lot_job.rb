module Copart
  class ScanLotJob < ApplicationJob
    queue_as :default

    def perform(copart_lot)
      # return unless copart_lot.scan_requested?

      # copart_lot.scan_start!
      ::Copart::NodeCommandSender.scan_lot(copart_lot.lot_number)
      # copart_lot.scan_complete!

      # ::ActionCable.server.broadcast("copart_lot_channel",  client_command: "reload")
    end
  end
end
