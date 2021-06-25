module Copart
  class LotPage
    delegate :name, :vehicle_id, :decorated_expenses, :expenses, :expenses?, to: :lot

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

    def expenses_debit_total
      expenses.debit.sum(:amount)
    end

    def expenses_credit_total
      expenses.credit.sum(:amount)
    end

    def expenses_grand_total
      expenses_debit_total - expenses_credit_total
    end

    private

    attr_reader :copart_lot_id
  end
end
