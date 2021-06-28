module Datastorage
  module Updaters
    class VehicleExpense
      def initialize(vehicle_id, expense_id, expense_attributes, recalc_amount: true)
        @vehicle_id = vehicle_id
        @expense_id = expense_id
        @expense_attributes = expense_attributes
        @recalc_amount = recalc_amount
      end

      def update
        expense = ::Datastorage::SimpleActions::VehicleExpense.new(vehicle_id, expense_id).find

        processor = ::Expenses::AttributesProcessor.new(expense_attributes, refresh_rate: refresh_rate?(expense))
        processor.process

        if processor.success?
          expense.update(processor.attributes)
        else
          expense.errors.add(:amount, :invalid, message: processor.error_message)
        end

        expense
      end

      private

      attr_reader :vehicle_id, :expense_id, :expense_attributes, :recalc_amount

      def refresh_rate?(expense)
        recalc_amount || expense_attributes[:currency] != expense.currency
      end
    end
  end
end
