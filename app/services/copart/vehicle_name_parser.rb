module Copart
  class VehicleNameParser
    VEHICLE_NAME_REGEX = /(\d{4}) (\S+) (.*)/
    YEAR_INDEX = 1
    MAKE_INDEX = 2
    MODEL_INDEX = 3

    def initialize(vehicle_name)
      @vehicle_name = vehicle_name
    end

    def call
      @match_result = vehicle_name.to_s.match(VEHICLE_NAME_REGEX)

      self
    end

    def year
      from_match_result(YEAR_INDEX)
    end

    def make
      from_match_result(MAKE_INDEX)
    end

    def model
      from_match_result(MODEL_INDEX)
    end

    private

    attr_reader :vehicle_name, :match_result

    def from_match_result(index)
      return if match_result.nil?

      match_result[index]
    end
  end
end
