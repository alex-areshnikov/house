module Vehicles
  module Folders
    class SelectorsController < ::ApplicationController
      def show
        @page = ::Vehicles::Folders::SelectorsPage.new(params[:vehicle_id], params[:quick_action_code])
      end
    end
  end
end
