module Datastorage
  module SimpleActions
    class VehicleExpense
      def initialize(vehicle_id, expense_id)
        @vehicle_id = vehicle_id
        @expense_id = expense_id
      end

      def find
        ::Vehicle.find(vehicle_id).expenses.find(expense_id)
      end

      def destroy
        find.destroy
      end

      private

      attr_reader :vehicle_id, :expense_id
    end
  end
end
