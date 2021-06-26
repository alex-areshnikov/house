module Vehicles
  class ExpensesPage
    attr_reader :vehicle_id

    def initialize(vehicle_id)
      @vehicle_id = vehicle_id
    end

    def expense_type_options
      ::Expense.expense_type.options
    end

    def currency_options
      ::Expense.currency.options
    end

    def category_options(expense)
      options = ::ExpenseCategory.pluck(:name)
      options << expense.category if expense.category.present?
      options.uniq.sort
    end

    def lot_id
      lot = ::Datastorage::Finders::CopartLot.by_vehicle_id(vehicle_id)
      lot.id
    end
  end
end
