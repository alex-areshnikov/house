module Datastorage
  class Creator
    CREATORS = {
      copart_lot: ->(attributes) { ::CopartLot.create!(attributes) }
    }

    def initialize(target_object, attributes)
      @target_object = target_object
      @attributes = attributes
    end

    def create
      CREATORS.fetch(target_object).call(attributes)
    end

    private

    attr_reader :target_object, :attributes
  end
end
