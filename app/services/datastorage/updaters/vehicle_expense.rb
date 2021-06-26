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

        processor = ::Expenses::AttributesProcessor.new(expense_attributes)
        processor.process

        if processor.success?
          expense.update(processor.attributes)
        else
          expense.errors.add(:amount, :invalid, message: processor.error_message)
        end

        expense
      end

      private

      attr_reader :vehicle_id, :expense_id, :expense_attributes
    end
  end
end
