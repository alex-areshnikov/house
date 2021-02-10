module Copart
  class NodeCommandSender
    SCAN_LOT_COMMAND = "scan-lot"
    AUCTION_COMMAND = "auction"

    def self.scan_lot(copart_lot)
      username = Rails.application.credentials.copart[:username]
      password = Rails.application.credentials.copart[:password]

      ::ActionCable.server.broadcast("house_node_channel", {
        command: SCAN_LOT_COMMAND, lot_number: copart_lot.lot_number, username: username, password: password
      })
    end
  end
end
