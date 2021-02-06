module Copart
  class ScannerDataLoader
    def initialize(data)
      @data = data["data"]
    end

    def call
      photo_urls = data.delete("photo_urls")

      ::Datastorage::Updater.new(:copart_lot, data).update_or_create
      ::Copart::PhotosSaver.new(data["lot_number"], photo_urls).call if photo_urls.present?
    end

    private

    attr_reader :data
  end
end
