module Copart
  class ScannersController < ::Copart::ApplicationController
    def show
      ::Copart::ScanLotJob.perform_later(lot_number)

      flash[:notice] = "Scanner executed for #{lot_number}"

      redirect_to copart_lots_path
    end

    private

    def lot_number
      scanner_params[:id]
    end

    def scanner_params
      params.permit(:id)
    end
  end
end
