module Vehicles
  class ExpenseDecorator
    delegate :id, :amount, :description, :expense_type, :expense_type_text, :refundable, :refunded, to: :expense

    def initialize(expense)
      @expense = expense
    end

    def amount_debit
      amount if expense_type == :debit
    end

    def amount_credit
      amount if expense_type == :credit
    end

    private

    attr_reader :expense
  end
end
