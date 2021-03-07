module Copart
  class CommandsController < ::Copart::ApplicationController
    def show
      copart_lot = find_lot
      ::Copart::NodeCommandSender.new(copart_lot).command_with_lot_number(params[:command])

      redirect_to copart_lots_path
    end

    private

    def scanner_params
      params.permit(:id, :command)
    end

    def find_lot
      ::CopartLot.find(scanner_params[:id])
    end
  end
end
