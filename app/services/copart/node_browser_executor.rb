module Copart
  class NodeBrowserExecutor
    SCAN = "scan"
    AUCTION = "auction"

    def initialize(lot_number, actionType)
      @lot_number = lot_number
      @action_type = actionType
    end

    def call
      username = Rails.application.credentials.copart[:username]
      password = Rails.application.credentials.copart[:password]

      `yarn scan_lot #{lot_number} #{username} #{password} #{action_type}`
    end

    private

    attr_reader :lot_number, :action_type
  end
end
