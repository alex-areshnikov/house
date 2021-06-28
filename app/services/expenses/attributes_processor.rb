module Expenses
  class AttributesProcessor
    delegate :error_message, to: :currency_processor

    attr_reader :attributes

    def initialize(attributes, refresh_rate: true)
      @attributes = attributes
      @refresh_rate = refresh_rate
    end

    def process
      process_currency
    end

    def success?
      currency_processor.present? ? currency_processor.success? : true
    end

    private

    def process_currency
      if attributes[:currency].to_s == "USD"
        attributes[:rate] = 1.0
      else
        populate_rate if refresh_rate
      end

      attributes[:usd_amount] = attributes[:amount].to_f * attributes[:rate].to_f
    end

    def populate_rate
      @currency_processor = ::External::CurrencyProcessor.new(from: attributes[:currency])
      currency_processor.process

      attributes[:rate] = currency_processor.rate if currency_processor.success?
    end

    attr_reader :currency_processor, :refresh_rate
  end
end
