module Holodilnic
  class Saver
    SENSORS_SLEEP_TIME_SECONDS = 5.seconds

    KEYS_MAPPING = {
      "temp_top" => :temperature_top_c,
      "temp_bottom" => :temperature_bottom_c
    }.freeze

    def call(sensors_data)
      sensors_data = transform_data(sensors_data)
      return if prev_sensors_data == sensors_data

      HolodilnicSensorsData.create(sensors_data)

      @prev_sensors_data = sensors_data
    end

    private

    attr_reader :prev_sensors_data

    def transform_data(data)
      data.transform_keys { |key| KEYS_MAPPING[key] || key }
    end
  end
end
