module Datastorage
  class Finder
    FINDERS = {
      copart_lot: ->(attributes) { ::CopartLot.where(lot_number: attributes["id"] || attributes["lot_number"]) },
      scheduled_copart_lots: ->(_) { ::CopartLot.scheduled_or_future },
      awaiting_copart_lots: ->(_) { ::CopartLot.added },
      scanning_more_than_ten_min_copart_lots: ->(_) { ::CopartLot.scanning.updated_more_than_x_minutes(10) },
      erred_copart_lots: ->(_) { ::CopartLot.erred },
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
