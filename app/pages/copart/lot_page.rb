module Copart
  class LotPage
    delegate :name, :vehicle_id, :expense_categories, :expenses, :expenses?, to: :lot

    attr_reader :lot

    def initialize(copart_lot_id)
      @copart_lot_id = copart_lot_id
    end

    def build
      @lot = ::Copart::LotDecorator.new(::CopartLot.find(copart_lot_id))
    end

    def suppress_vehicle_actions?
      true
    end

    def expenses_debit_total_by_category(category)
      expenses.where(category: category).debit.sum(:usd_amount)
    end

    def expenses_credit_total_by_category(category)
      expenses.where(category: category).credit.sum(:usd_amount)
    end

    def expenses_grand_total_by_category(category)
      expenses_debit_total_by_category(category) - expenses_credit_total_by_category(category)
    end

    def expenses_debit_total
      expenses.debit.sum(:usd_amount)
    end

    def expenses_credit_total
      expenses.credit.sum(:usd_amount)
    end

    def expenses_grand_total
      expenses_debit_total - expenses_credit_total
    end

    def decorated_expenses_by_category(category)
      lot.decorated_expenses_by_category(category)
    end

    private

    attr_reader :copart_lot_id
  end
end
