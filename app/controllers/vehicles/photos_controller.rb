module Vehicles
  class PhotosController < ::ApplicationController
    before_action :authenticate_user!

    def index
      load_page
    end

    def create
      folder = ::Datastorage::Creators::VehiclePhotoFolder.new(vehicle, params[:folder_id], folder_params).create

      if folder.valid?
        flash[:notice] = "Folder was created successfully."
      else
        flash[:alert] = "Error creating #{folder.name} folder. #{folder.errors.full_messages.first}."
      end

      redirect_to vehicle_folder_photos_path(vehicle, params[:folder_id])
    end

    private

    def folder_params
      params.require(:folder).permit(:name)
    end

    private

    def vehicle
      @_vehicle = ::Vehicle.find(params[:vehicle_id])
    end

    def load_page
      @page = ::Vehicles::PhotosPage.new(params[:vehicle_id], params[:folder_id])
    end
  end
end
