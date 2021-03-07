module Copart
  class ErredLotsResetter
    def reset
      ::Datastorage::Finder.new(:erred_copart_lots).find_each do |copart_lot|
        copart_lot.reset!
      end
    end

    def delete
      ::Datastorage::Finder.new(:erred_copart_lots).find_each do |copart_lot|
        copart_lot.destroy
      end
    end
  end
end
