module Vehicles
  class PhotosController < ::ApplicationController
    before_action :authenticate_user!

    def new
      @page = ::Vehicles::FoldersPage.new(params[:vehicle_id], current_folder_id: params[:folder_id])
    end

    def create
      if photo_params[:photo].blank?
        flash[:alert] = "Please select at least 1 photo"
        redirect_back(fallback_location: vehicle_folders_path(params[:vehicle_id]))
      else
        ::Datastorage::Creators::VehiclePhotos.new(params[:vehicle_id], params[:folder_id], photo_params[:photo], photo_params[:description]).create

        page = ::Vehicles::FoldersPage.new(params[:vehicle_id], current_folder_id: params[:folder_id])

        redirect_to page.folder_path
      end
    end

    private

    def photo_params
      params.fetch(:photo, {}) .permit(:description, photo: [])
    end
  end
end
