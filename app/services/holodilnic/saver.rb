module Holodilnic
  class Saver
    SENSORS_SLEEP_TIME_SECONDS = 5.seconds

    def call(sensors_data)
      return if prev_sensors_data == sensors_data

      HolodilnicSensorsData.create(adjusted_prev_sensors_data) if prev_sensors_data.present?
      HolodilnicSensorsData.create(sensors_data)

      @prev_sensors_data = sensors_data
    end

    private

    attr_reader :prev_sensors_data

    def adjusted_prev_sensors_data
      prev_sensors_data.merge(created_at: Time.current - SENSORS_SLEEP_TIME_SECONDS)
    end
  end
end
