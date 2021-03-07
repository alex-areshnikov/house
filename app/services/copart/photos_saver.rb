module Copart
  class PhotosSaver
    def initialize(lot_number, photo_urls)
      @lot_number = lot_number
      @photo_urls = photo_urls
    end

    def call
      copart_lot = ::Datastorage::Finder.new(:copart_lot, {"lot_number" => lot_number}).find
      return if copart_lot.blank?

      copart_lot.copart_lot_photos.destroy_all

      photo_urls.each do |_, photo_url|
        ::Datastorage::Creator.new(:copart_lot_photo, { copart_lot: copart_lot, remote_photo_url: photo_url }).create
      end
    end

    private

    attr_reader :lot_number, :photo_urls
  end
end
