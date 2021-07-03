module Vehicles
  class FoldersController < ::ApplicationController
    before_action :authenticate_user!

    def destroy
      vehicle.folders.find(params[:id]).destroy

      redirect_to vehicle_folder_photos_path(params[:vehicle_id], :root)
    end

    private

    def vehicle
      @_vehicle = ::Vehicle.find(params[:vehicle_id])
    end
  end
end
