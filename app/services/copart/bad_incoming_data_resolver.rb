module Copart
  class BadIncomingDataResolver
    def initialize(data)
      @data = data
    end

    def call
      puts "Bad incoming data: #{data}"
      # raise StandardError, "Bad incoming data: #{data}"
    end

    private

    attr_reader :data
  end
end
