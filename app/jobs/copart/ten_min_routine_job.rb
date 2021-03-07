module Copart
  class TenMinRoutineJob < ApplicationJob
    queue_as :default

    def perform
      scan_awaiting_lots
      error_outdated_scanning_lots
    end

    private

    def scan_awaiting_lots
      ::Datastorage::Finder.new(:awaiting_copart_lots).find_each do |copart_lot|
        ::Copart::NodeCommandSender.new(copart_lot).scan_lot
      end
    end

    def error_outdated_scanning_lots
      ::Datastorage::Finder.new(:scanning_more_than_ten_min_copart_lots).find_each do |copart_lot|
        copart_lot.error!
      end
    end
  end
end
