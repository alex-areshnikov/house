module Vehicles
  class FoldersController < ::ApplicationController
    before_action :authenticate_user!

    ROOT = "root"

    def index
      @page = ::Vehicles::FoldersPage.new(params[:vehicle_id], current_folder_id: ::Vehicles::FoldersPage::ROOT, edit_mode: params[:edit].present?)

      render :show
    end

    def show
      @page = ::Vehicles::FoldersPage.new(params[:vehicle_id], current_folder_id: params[:id], edit_mode: params[:edit].present?)
    end

    def create
      @page = ::Vehicles::FoldersPage.new(params[:vehicle_id], parent_folder_id: params[:parent_folder_id])
      folder = ::Folder.create(folder_params.merge(owner: @page.parent_entity))

      unless folder.valid?
        flash[:alert] = "Error creating #{folder.name} folder. #{folder.errors.full_messages.first}."
      end

      redirect_to @page.parent_folder_redirect_path
    end

    def destroy
      @page = ::Vehicles::FoldersPage.new(params[:vehicle_id], current_folder_id: params[:id])
      redirect_path = @page.parent_folder_redirect_path
      @page.destroy_current_folder

      redirect_to redirect_path
    end

    private

    def folder_params
      params.require(:folder).permit(:name)
    end
  end
end
