module Datastorage
  class Finder
    FINDERS = {
      copart_lot: ->(attributes) { ::CopartLot.where(lot_number: attributes["id"] || attributes["lot_number"]) },
      copart_lot_vehicle: ->(attributes) do
        ::Vehicle.joins(:copart_lot).where(copart_lot: { lot_number: attributes["id"] || attributes["lot_number"]})
      end,

      scheduled_copart_lots: ->(_) { ::CopartLot.scheduled_or_future },
      awaiting_copart_lots: ->(_) { ::CopartLot.added },
      future_copart_lots: ->(_) { ::CopartLot.future },
      scanning_copart_lots: ->(_) { ::CopartLot.scanning },
      erred_copart_lots: ->(_) { ::CopartLot.erred },
      missing_photos_copart_lots: ->(_) { ::CopartLot.missing_photos }
    }

    def initialize(target_object, attributes = {})
      @target_object = target_object
      @attributes = attributes
    end

    def find_each
      FINDERS.fetch(target_object).call(attributes).find_each do |record|
        yield record
      end
    end

    def find
      FINDERS.fetch(target_object).call(attributes).first
    end

    def exists?
      FINDERS.fetch(target_object).call(attributes).exists?
    end

    private

    attr_reader :target_object, :attributes
  end
end
