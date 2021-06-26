module Datastorage
  module Creators
    class VehicleExpense
      def initialize(vehicle_id, expense_attributes)
        @vehicle_id = vehicle_id
        @expense_attributes = expense_attributes
      end

      def create
        vehicle = ::Vehicle.find(vehicle_id)
        vehicle.expenses.create(expense_attributes)
      end

      private

      attr_reader :vehicle_id, :expense_attributes
    end
  end
end
