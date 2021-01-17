module Datastorage
  class Updater
    UPDATERS = {
      copart_lot: ->(attributes) {
        ar_copart_lot = ::Datastorage::Finder.new(:copart_lot, attributes).find
        ar_copart_lot.update!(attributes)
      }
    }

    def initialize(target_object, attributes)
      @target_object = target_object
      @attributes = attributes
    end

    def update
      UPDATERS.fetch(target_object).call(attributes)
    end

    def update_or_create
      ::Datastorage::Finder.new(:copart_lot, attributes).exists? ?
        update :
        ::Datastorage::Creator.new(:copart_lot, attributes).create
    end

    private

    attr_reader :target_object, :attributes
  end
end
