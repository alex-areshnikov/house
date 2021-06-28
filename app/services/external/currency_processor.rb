require 'uri'
require 'net/http'
require 'json'

module External
  class CurrencyProcessor
    CURRCONV_API_KEY = "1ab0192eb709d8361bf8".freeze
    REQUEST_URL = "https://free.currconv.com/api/v7/convert?q=from_currency_to_currency&compact=ultra&apiKey=#{CURRCONV_API_KEY}"

    attr_reader :error_message, :rate

    def initialize(from:, to: :USD)
      @from = from.to_s.upcase
      @to = to.to_s.upcase
      @error_message = nil
      @rate = 1.0
    end

    def process
      request_url = REQUEST_URL.sub("from_currency", from).sub("to_currency", to)

      response = Net::HTTP.get_response(URI(request_url))
      parsed_response = JSON.parse(response.body)

      if parsed_response.has_key?(rate_key)
        @rate = parsed_response[rate_key].to_f
      else
        @error_message = "Rate for #{from}/#{to} was not found"
      end

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

    attr_reader :from, :to
  end
end
