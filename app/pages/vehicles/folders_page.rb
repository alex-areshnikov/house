module Vehicles
  class FoldersPage
    include Rails.application.routes.url_helpers

    ROOT = "root"

    delegate :name, :photos, to: :vehicle, prefix: true
    delegate :id, :name, :photos, to: :entity, prefix: true

    attr_reader :vehicle_id

    def initialize(vehicle_id, parent_folder_id: nil, current_folder_id: nil, edit_mode: false)
      @vehicle_id = vehicle_id
      @parent_folder_id = parent_folder_id
      @current_folder_id = current_folder_id
      @edit_mode = edit_mode

      raise StandardError, "Current or Parent Folder ID must be supplied" if parent_folder_id.nil? && current_folder_id.nil?
    end

    def breadcrumbs
      breadcrumbs_build = breadcrumbs_all

      last_element = breadcrumbs_build.delete_at(-1)
      breadcrumbs_build << { name: last_element[:name] }
    end

    def back_path
      return copart_lots_path(purchased: 1) if root_folder?

      breadcrumbs[-2][:path]
    end

    def folder_path
      breadcrumbs_all[-1][:path]
    end

    def edit_folder_path
      "#{folder_path}?edit=1"
    end

    def parent_folder_redirect_path
      parent_root_folder? ? vehicle_folders_path(vehicle_id) : vehicle_folder_path(vehicle_id, parent_folder.id)
    end

    def destroy_current_folder
      current_folder.destroy
    end

    def entity_photos
      entity.photos.order(:created_at)
    end

    def child_folders
      entity.folders.order(:created_at).map do
        { name: _1.name, path: vehicle_folder_path(vehicle_id, _1.id) }
      end
    end

    def root_folder?
      current_folder_id == ROOT
    end

    def parent_root_folder?
      parent_folder_id == ROOT
    end

    def root_or_folder_id
      return ROOT if root_folder?

      current_folder_id
    end

    def vehicle
      @vehicle = ::VehicleDecorator.new(::Vehicle.find(vehicle_id))
    end

    def entity
      root_folder? ? vehicle : current_folder
    end

    def parent_entity
      parent_root_folder? ? ::Vehicle.find(vehicle_id) : parent_folder
    end

    def current_folder_name
      return "" if current_folder_id.nil?
      return "Root" if root_folder?

      current_folder.name
    end

    def edit?
      edit_mode
    end

    private

    attr_reader :edit_mode

    def breadcrumbs_all(current_obj = entity, breadcrumbs_build = [])
      if current_obj.is_a? ::Folder
        breadcrumbs_build.unshift(name: current_obj.name, path: vehicle_folder_path(vehicle_id, current_obj.id))
        breadcrumbs_all(current_obj.owner, breadcrumbs_build)
      else
        breadcrumbs_build.unshift(name: vehicle_name, path: vehicle_folders_path(vehicle_id))
      end
    end

    def parent_folder
      @parent_folder = ::Folder.find(parent_folder_id)
    end

    def current_folder
      @current_folder = ::Folder.find(current_folder_id)
    end

    def current_folder_id
      raise StandardError, "Current Folder ID was not supplied" if @current_folder_id.nil?

      @current_folder_id
    end

    def parent_folder_id
      calc_parent_folder_id if @parent_folder_id.nil?

      @parent_folder_id
    end


    def calc_parent_folder_id
      @parent_folder_id = ROOT if current_folder_id == ROOT || !current_folder.owner.is_a?(::Folder)

      @parent_folder_id = current_folder.owner_id if @parent_folder_id.nil?
    end
  end
end
