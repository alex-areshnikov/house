module Copart
  class ScannersController < ::Copart::ApplicationController
    def show
      copart_lot = find_lot
      # copart_lot.scan!
      ::Copart::NodeCommandSender.scan_lot(copart_lot.lot_number)

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
