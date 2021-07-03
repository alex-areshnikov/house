module Vehicles
  class FoldersPage
    include Rails.application.routes.url_helpers

    ROOT = "root"

    delegate :name, :photos, to: :vehicle, prefix: true
    delegate :id, :name, :photos, to: :entity, prefix: true

    attr_reader :vehicle_id, :parent_folder_id

    def initialize(vehicle_id, parent_folder_id = ROOT, current_folder_id = ROOT)
      @vehicle_id = vehicle_id
      @parent_folder_id = parent_folder_id
      @current_folder_id = current_folder_id
    end

    def breadcrumbs(current_obj = entity, breadcrumbs_build = [])
      if current_obj.is_a? ::Folder
        parent_folder_id = (current_obj.owner.is_a?(::Folder) ? current_obj.owner_id : ROOT)
        path = vehicle_parent_folder_folder_path(vehicle_id, parent_folder_id, current_obj.id)
        breadcrumbs_build.unshift(name: current_obj.name, path: path)
        breadcrumbs(current_obj.owner, breadcrumbs_build)
      else
        breadcrumbs_build.unshift(name: vehicle_name, path: vehicle_folders_path(vehicle_id))
      end

      last_element = breadcrumbs_build.delete_at(-1)
      breadcrumbs_build << { name: last_element[:name] }
    end

    def back_path
      return copart_lots_path(purchased: 1) if root_folder?

      breadcrumbs[-2][:path]
    end

    def parent_folder_redirect_path
      if parent_root_folder?
        vehicle_folders_path(vehicle_id)
      else
        owner_id = parent_folder.owner.is_a?(::Folder) ? parent_folder.owner_id : ROOT
        vehicle_parent_folder_folder_path(vehicle_id, owner_id, parent_folder.id)
      end
    end

    def destroy_current_folder
      current_folder.destroy
    end

    def entity_photos
      entity.photos.order(:created_at)
    end

    def child_folders
      entity.folders.order(:created_at).map do
        { name: _1.name, path: vehicle_parent_folder_folder_path(vehicle_id, root_folder? ? ROOT : _1.owner_id, _1.id) }
      end
    end

    def root_folder?
      current_folder_id == ROOT
    end

    def parent_root_folder?
      parent_folder_id == ROOT
    end

    def vehicle
      @_vehicle = ::VehicleDecorator.new(::Vehicle.find(vehicle_id))
    end

    def entity
      root_folder? ? vehicle : current_folder
    end

    def parent_entity
      parent_root_folder? ? ::Vehicle.find(vehicle_id) : parent_folder
    end

    private

    def parent_folder
      @_parent_folder = ::Folder.find(parent_folder_id)
    end

    def current_folder
      @_current_folder = ::Folder.find(current_folder_id)
    end

    attr_reader :current_folder_id
  end
end
