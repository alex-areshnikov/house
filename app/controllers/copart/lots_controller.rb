module Copart
  class LotsController < ::Copart::ApplicationController
    before_action :enable_copart_lot_channel, only: :index

    def enable_copart_lot_channel
      enable_channel(:copart_lot)
    end

    def index
      @page = ::Copart::LotsPage.new(params[:page], params[:query])
    end

    def new
      @lot = ::CopartLot.new
    end

    def create
      @lot = ::CopartLot.new(copart_lot_params.merge(vehicle: ::Vehicle.new))
      if @lot.save
        ::Copart::NodeCommandSender.new(@lot).scan_lot

        redirect_to copart_lots_path
      else
        render "new"
      end
    end

    def destroy
      CopartLot.find(params[:id]).destroy

      redirect_to copart_lots_path(query: params.permit![:query])
    end

    private

    def copart_lot_params
      params.require(:copart_lot).permit(:lot_number)
    end
  end
end
