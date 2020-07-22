require "mqtt"

module Holodilnic
  class MqttListener
    TOPIC = "holodilnic/data"

    def initialize
      @sensors_data_saver = Holodilnic::Saver.new
    end

    def call
      MQTT::Client.connect(Rails.application.credentials.mqtt[:host]) do |client|
        puts "MQTT connected"

        client.subscribe(TOPIC)

        client.get(TOPIC) do |_, message|
          sensors_data_saver.call(JSON.parse(message))
        rescue JSON::ParserError
          puts "Bad JSON: #{message}"
        end
      end
    end

    private

    attr_reader :sensors_data_saver
  end
end
