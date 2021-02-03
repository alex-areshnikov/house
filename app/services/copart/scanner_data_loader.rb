module Copart
  class ScannerDataLoader
    def initialize(data)
      @data = data["data"]
    end

    def call
      ::Datastorage::Updater.new(:copart_lot, data).update_or_create
      ::ActionCable.server.broadcast("copart_lot_channel",  client_command: "reload")
    end

    private

    attr_reader :data
  end
end
