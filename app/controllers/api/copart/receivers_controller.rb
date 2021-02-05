module Api
  module Copart
    class ReceiversController < ::Api::ApplicationController
      def create
        ::Copart::DataResolverFactory.for_communicator(receiver_params).call
      end

      private

      def receiver_params
        params.permit(:communicator, data: [
          :lot_number, :name, :vin, :primary_damage, :secondary_damage, :sale_date, :timestamp, :message, :error, :stack
        ])
      end
    end
  end
end