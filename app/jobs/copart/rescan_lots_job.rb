module Copart
  class RescanLotsJob < ApplicationJob
    queue_as :default

    def perform
      ::Datastorage::Finder.new(:scheduled_copart_lots).find_each do |copart_lot|
        puts "rescanning for #{copart_lot.lot_number}"
      end
    end
  end
end
