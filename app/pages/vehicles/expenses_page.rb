module Vehicles
  class ExpensesPage
    attr_reader :vehicle_id

    def initialize(vehicle_id)
      @vehicle_id = vehicle_id
    end

    def expense_type_options
      ::Expense.expense_type.options
    end

    def lot_id
      lot = ::Datastorage::Finders::CopartLot.by_vehicle_id(vehicle_id)
      lot.id
    end
  end
end
