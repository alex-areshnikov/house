module Copart
  class NodeCommandSender
    SCAN_LOT_COMMAND = "scan-lot"
    AUCTION_COMMAND = "auction"

    def self.scan_lot(copart_lot)
      ::ActionCable.server.broadcast("house_node_channel", {
        command: SCAN_LOT_COMMAND, lot_number: copart_lot.lot_number
      })
    end
  end
end
