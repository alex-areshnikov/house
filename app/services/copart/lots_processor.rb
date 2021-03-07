module Copart
  class LotsProcessor
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
