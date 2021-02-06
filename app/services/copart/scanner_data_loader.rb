module Copart
  class ScannerDataLoader
    def initialize(data)
      @data = data["data"]
    end

    def call
      photo_urls = data.delete("photo_urls")
      puts photo_urls.inspect

      ::Datastorage::Updater.new(:copart_lot, data).update_or_create
    end

    private

    attr_reader :data
  end
end
