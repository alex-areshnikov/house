module Vehicles
  class SelectedPhotosController < ::ApplicationController
    before_action :authenticate_user!

    def create
      @page = ::Vehicles::FoldersPage.new(params[:vehicle_id], current_folder_id: params[:folder_id])

      if selected_photos_params[:selected_photo_ids].blank?
        flash[:alert] = "Please select at least 1 photo"
      else
        ::Vehicles::SelectedPhotosProcessor.new(
          owner: @page.entity,
          action_text: selected_photos_params[:commit],
          selected_photo_ids: selected_photos_params[:selected_photo_ids]).call
      end

      redirect_to @page.edit_folder_path
    end

    private

    def selected_photos_params
      params.permit(:authenticity_token, :commit, :vehicle_id, :folder_id, selected_photo_ids: [])
    end
  end
end
