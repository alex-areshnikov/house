module Copart
  class NodeCommandSender
    SCAN_LOT_COMMAND = "scan-lot"
    COLLECT_LOT_PHOTOS_COMMAND = "collect-lot-photos"
    WATCH_AUCTION_COMMAND = "watch-auction"
    CLOSE_AUCTION_COMMAND = "close-auction"

    def initialize(copart_lot)
      @copart_lot = copart_lot
    end

    def scan_lot
      command_with_lot_number(SCAN_LOT_COMMAND)
    end

    def collect_lot_photos
      command_with_lot_number(COLLECT_LOT_PHOTOS_COMMAND)
    end

    def command_with_lot_number(command)
      request_scan! if command == SCAN_LOT_COMMAND

      ::ActionCable.server.broadcast("house_node_channel", { command: command, lot_number: copart_lot.lot_number })
    end

    private

    attr_reader :copart_lot

    def request_scan!
      copart_lot.scan!
    end
  end
end
