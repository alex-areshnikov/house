module Copart
  class NodeCommandSender
    SCAN_LOT_COMMAND = "scan-lot"
    COLLECT_LOT_PHOTOS_COMMAND = "collect-lot-photos"

    def self.scan_lot(lot_number)
      command_with_lot_number(SCAN_LOT_COMMAND, lot_number)
    end

    def self.collect_lot_photos(lot_number)
      command_with_lot_number(COLLECT_LOT_PHOTOS_COMMAND, lot_number)
    end

    private

    def self.command_with_lot_number(command, lot_number)
      ::ActionCable.server.broadcast("house_node_channel", { command: command, lot_number: lot_number })
    end
  end
end
