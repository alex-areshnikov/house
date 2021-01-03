module Copart
  class LotsController < ::Copart::ApplicationController
    def index
      @lots = CopartLot.all
    end

    def new
      @lot = CopartLot.new
    end

    def create
      @lot = CopartLot.new(copart_lot_params)
      if @lot.save
        redirect_to copart_lots_path
      else
        render "new"
      end
    end

    def destroy
      kiwi = CopartLot.find(params[:id])
      kiwi.destroy
      redirect_to copart_lots_path
    end

    private

    def copart_lot_params
      params.require(:copart_lot).permit(:lot_number)
    end
  end
end
