module Datastorage
  class Finder
    FINDERS = {
      copart_lot: ->(attributes) { ::CopartLot.where(lot_number: attributes["lot_number"]) }
    }

    def initialize(target_object, attributes)
      @target_object = target_object
      @attributes = attributes
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
