module Vehicles
  class ExpenseDecorator
    CURRENCY_TO_UNIT_MAP = {
      "USD" => "$",
      "EUR" => "€",
      "BYN" => "Br"
    }

    delegate :id, :amount, :usd_amount, :description, :expense_type, :expense_type_text, :currency, :refundable, :refunded, to: :expense

    def initialize(expense)
      @expense = expense
    end

    def amount_debit
      usd_amount if expense_type == :debit
    end

    def original_amount_debit
      amount if expense_type == :debit
    end

    def amount_credit
      usd_amount if expense_type == :credit
    end

    def original_amount_credit
      amount if expense_type == :credit
    end

    def unit
      CURRENCY_TO_UNIT_MAP.fetch(expense.currency)
    end

    def extra_html_classes
      "underline" unless usd?
    end

    def usd?
      currency == "USD"
    end

    private

    attr_reader :expense
  end
end
