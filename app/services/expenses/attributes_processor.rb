module Expenses
  class AttributesProcessor
    delegate :error_message, to: :converter

    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def process
      process_currency
    end

    def success?
      converter.present? ? converter.success? : true
    end

    private

    def process_currency
      if attributes[:currency] == :USD
        attributes[:usd_amount] = attributes[:amount]
      else
        convert_amount
      end
    end

    def convert_amount
      @converter = ::External::CurrencyConverter.new(amount: attributes[:amount], from: attributes[:currency])
      converter.convert

      attributes[:usd_amount] = converter.converted_amount if converter.success?
    end

    attr_reader :converter
  end
end
