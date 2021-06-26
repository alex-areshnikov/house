module Datastorage
  module Updaters
    class VehicleExpense
      def initialize(vehicle_id, expense_id, expense_attributes)
        @vehicle_id = vehicle_id
        @expense_id = expense_id
        @expense_attributes = expense_attributes
      end

      def update
        expense = ::Datastorage::SimpleActions::VehicleExpense.new(vehicle_id, expense_id).find
        expense.update(expense_attributes)
        expense
      end

      private

      attr_reader :vehicle_id, :expense_id, :expense_attributes
    end
  end
end
