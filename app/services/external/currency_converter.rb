require 'uri'
require 'net/http'
require 'json'

module External
  class CurrencyConverter
    CURRCONV_API_KEY = "1ab0192eb709d8361bf8".freeze
    REQUEST_URL = "https://free.currconv.com/api/v7/convert?q=from_currency_to_currency&compact=ultra&apiKey=#{CURRCONV_API_KEY}"

    attr_reader :error_message, :converted_amount, :rate

    def initialize(amount:, from:, to: :USD)
      @amount = amount
      @from = from.to_s.upcase
      @to = to.to_s.upcase
      @error_message = nil
      @rate = nil
      @converted_amount = nil
    end

    def convert
      request_url = REQUEST_URL.sub("from_currency", from).sub("to_currency", to)

      uri = URI(request_url)
      response = Net::HTTP.get_response(uri)

      parsed_response = JSON.parse(response.body)
      @error_message = "Rate for #{from}/#{to} was not found" unless parsed_response.has_key?(rate_key)

      @rate = parsed_response[rate_key].to_f
      @converted_amount = amount.to_f * rate

      success?
    rescue ::StandardError => error
      @error_message = error.message

      false
    end

    def success?
      error_message.blank?
    end

    private

    def rate_key
      "#{from}_#{to}"
    end

    attr_reader :amount, :from, :to
  end
end
