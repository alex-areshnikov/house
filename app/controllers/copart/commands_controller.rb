module Copart
  class CommandsController < ::Copart::ApplicationController
    def show
      copart_lot = find_lot
      # copart_lot.scan!
      ::Copart::NodeCommandSender.command_with_lot_number(params[:command], copart_lot.lot_number)

      redirect_to copart_lots_path
    end

    private

    def scanner_params
      params.permit(:id)
    end

    def find_lot
      ::CopartLot.find(scanner_params[:id])
    end
  end
end
