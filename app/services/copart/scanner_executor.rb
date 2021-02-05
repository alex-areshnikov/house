module Copart
  class ScannerExecutor
    def initialize(lot_number)
      @lot_number = lot_number
    end

    def call
      username = Rails.application.credentials.copart[:username]
      password = Rails.application.credentials.copart[:password]
      
      `yarn scan_lot #{lot_number} #{username} #{password}`
    end

    private

    attr_reader :lot_number
  end
end
