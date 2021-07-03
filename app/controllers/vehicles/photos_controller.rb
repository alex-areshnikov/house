module Vehicles
  class PhotosController < ::ApplicationController
    before_action :authenticate_user!

    def create
      if photo_params.empty?
        flash[:alert] = "Please select at least 1 photo"
      else
        ::Datastorage::Creators::VehiclePhotos.new(params[:vehicle_id], params[:folder_id], photo_params[:photo]).create
      end

      redirect_back(fallback_location: vehicle_folders_path(params[:vehicle_id]))
    end

    def destroy
      ::Photo.find(params[:id]).destroy

      redirect_back(fallback_location: vehicle_folders_path(params[:vehicle_id]))
    end

    private

    def photo_params
      params.fetch(:photo, {}) .permit(photo: [])
    end
  end
end
