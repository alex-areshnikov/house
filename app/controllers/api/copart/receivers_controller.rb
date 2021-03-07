module Api
  module Copart
    class ReceiversController < ::Api::ApplicationController
      def create
        ::Copart::DataResolverFactory.for_communicator(receiver_params).call
      end

      private

      def receiver_params
        params.permit(:communicator, data: [
          :lot_number, :name, :vin, :primary_damage, :secondary_damage, :sale_date, :doc_type, :odometer, :engine_type,
          :location, :timestamp, :message, :error, :stack, :level, :source, :scan_start, photo_urls: []
        ])
      end
    end
  end
end
