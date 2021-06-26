module Datastorage
  module Creators
    class VehicleExpense
      def initialize(vehicle_id, expense_attributes)
        @vehicle_id = vehicle_id
        @expense_attributes = expense_attributes
      end

      def create
        vehicle = ::Vehicle.find(vehicle_id)
        processor = ::Expenses::AttributesProcessor.new(expense_attributes)
        processor.process

        if processor.success?
          vehicle.expenses.create(processor.attributes)
        else
          expense = vehicle.expenses.build(expense_attributes)
          expense.errors.add(:amount, :invalid, message: processor.error_message)
          expense
        end
      end

      private

      attr_reader :vehicle_id, :expense_attributes
    end
  end
end
