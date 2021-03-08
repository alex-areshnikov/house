module Copart
  class LotsProcessorsPage
    RESCAN_AWAITING = "rescan_awaiting".freeze
    RESCAN_ERRED = "rescan_erred".freeze
    DELETE_ERRED = "delete_erred".freeze
    COLLECT_MISSING_PHOTOS = "collect_missing_photos".freeze

    attr_reader :flash_notice_message

    def initialize(process_item)
      @process_item = process_item
      @lots_processor = ::Copart::LotsProcessor.new
      @flash_notice_message = nil
    end

    def process
      rescan_awaiting if process_item == RESCAN_AWAITING
      rescan_erred if process_item == RESCAN_ERRED
      delete_erred if process_item == DELETE_ERRED
      collect_missing_photos if process_item == COLLECT_MISSING_PHOTOS
    end

    def awaiting_count
      ::CopartLot.added.count
    end

    def erred_count
      ::CopartLot.erred.count
    end

    def missing_photos_count
      ::CopartLot.missing_photos.count.keys.count
    end

    private

    def rescan_awaiting
      @flash_notice_message = "Rescan awaiting requested"
      @lots_processor.rescan_awaiting
    end

    def rescan_erred
      @flash_notice_message = "Rescan erred requested"
      @lots_processor.reset_erred
    end

    def delete_erred
      @flash_notice_message = "Delete erred requested"
      @lots_processor.destroy_erred
    end

    def collect_missing_photos
      @flash_notice_message = "Collect missing photos requested"
      @lots_processor.collect_missing_photos
    end

    attr_reader :process_item
  end
end
