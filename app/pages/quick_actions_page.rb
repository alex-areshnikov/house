class QuickActionsPage
  include Rails.application.routes.url_helpers

  attr_reader :action_code

  PATH_MAPPING = {
    add_expense: :new_vehicle_expense_path,
    show_expenses: :copart_lot
  }

  def initialize(action_code)
    @action_code = action_code
  end

  def vehicles
    ::Vehicle.purchased.map { ::VehicleDecorator.new(_1) }
  end

  def action_path(vehicle_id)
    send("build_#{action_code}_path", vehicle_id)
  end

  private

  def build_upload_photo_path(vehicle_id)
    vehicle_quick_action_folders_selector_path(vehicle_id, action_code)
  end

  def build_add_expense_path(vehicle_id)
    new_vehicle_expense_path(vehicle_id)
  end

  def build_show_expenses_path(vehicle_id)
    copart_lot_path(::CopartLot.find_by(vehicle_id: vehicle_id))
  end
end
