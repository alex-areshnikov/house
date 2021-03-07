module Copart
  class TenMinutesRoutineJob < ApplicationJob
    queue_as :default

    def perform
      scan_awaiting_lots
      # scan_missing_photos
    end

    private

    def scan_awaiting_lots
      ::Datastorage::Finder.new(:awaiting_copart_lots).find_each do |copart_lot|
        ::Copart::NodeCommandSender.new(copart_lot).scan_lot
      end
    end
  end
end
