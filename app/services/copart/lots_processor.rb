module Copart
  class LotsProcessor
    def collect_missing_photos
      missing_photos_lots { ::Copart::NodeCommandSender.new(_1).collect_lot_photos }
    end

    def rescan_awaiting
      awaiting_lots { ::Copart::NodeCommandSender.new(_1).scan_lot }
    end

    def rescan_future
      future_lots { ::Copart::NodeCommandSender.new(_1).scan_lot }
    end

    def reset_erred
      erred_lots { reset _1 }
    end

    def destroy_erred
      erred_lots { _1.destroy }
    end

    def reset_scanning
      scanning_lots { reset _1 }
    end

    def destroy_scanning
      scanning_lots { _1.destroy }
    end

    private

    def missing_photos_lots
      ::Datastorage::Finder.new(:missing_photos_copart_lots).find_each { yield _1 }
    end

    def awaiting_lots
      ::Datastorage::Finder.new(:awaiting_copart_lots).find_each { yield _1 }
    end

    def future_lots
      ::Datastorage::Finder.new(:future_copart_lots).find_each { yield _1 }
    end

    def erred_lots
      ::Datastorage::Finder.new(:erred_copart_lots).find_each { yield _1 }
    end

    def scanning_lots
      ::Datastorage::Finder.new(:scanning_copart_lots).find_each { yield _1 }
    end

    def reset(copart_lot)
      copart_lot.reset!
      ::Copart::NodeCommandSender.new(copart_lot).scan_lot
    end
  end
end
