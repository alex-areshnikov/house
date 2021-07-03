module Vehicles
  class PhotosPage
    include Rails.application.routes.url_helpers

    ROOT = "root"

    delegate :name, :photos, to: :vehicle, prefix: true
    delegate :id, :name, :photos, to: :entity, prefix: true

    attr_reader :vehicle_id

    def initialize(vehicle_id, folder_id = ROOT)
      @vehicle_id = vehicle_id
      @folder_id = folder_id
    end

    def breadcrumbs(current_obj = entity, breadcrumbs_build = [])
      if current_obj.is_a? ::Folder
        breadcrumbs_build.unshift(name: current_obj.name, path: vehicle_folder_photos_path(vehicle_id, current_obj.id))
        breadcrumbs(current_obj.owner, breadcrumbs_build)
      else
        breadcrumbs_build.unshift(name: vehicle_name, path: vehicle_folder_photos_path(vehicle_id, :root))
      end

      last_element = breadcrumbs_build.delete_at(-1)
      breadcrumbs_build << { name: last_element[:name] }
    end

    def back_path
      return copart_lots_path(purchased: 1) if root_folder?

      breadcrumbs[-2][:path]
    end

    def entity_photos
      entity.photos.order(:created_at)
    end

    def child_folders
      entity.folders.order(:created_at)
    end

    def root_folder?
      folder_id == ROOT
    end

    def vehicle
      @_vehicle = ::VehicleDecorator.new(::Vehicle.find(vehicle_id))
    end

    private

    def entity
      root_folder? ? vehicle : folder
    end

    def folder
      @_folder = ::Folder.find(folder_id)
    end

    attr_reader :folder_id
  end
end
