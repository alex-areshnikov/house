# frozen_string_literal: true
require "rails_helper"

describe ::Holodilnic::Saver do
  include ActiveSupport::Testing::TimeHelpers
  subject { described_class.new }

  let(:sensors_data) { { sensor_data: 1 } }
  let(:sensors_data_2) { { sensor_data: 2 } }

  let(:real_sensors_data) do
    {
      "humidity_top" => 47.0,
      "temp_top" => 21.8,
      "humidity_bottom" => 47.1,
      "temp_bottom" => 21.5
    }
  end

  let(:transformed_sensors_data) do
    {
      "humidity_top" => 47.0,
      temperature_top_c: 21.8,
      "humidity_bottom" => 47.1,
      temperature_bottom_c: 21.5
    }
  end

  it "saves changed data" do
    travel_to Date.new(2010, 5, 20) do
      expect(HolodilnicSensorsData).to receive(:create).once.with(sensor_data: 1)
      expect(HolodilnicSensorsData).to receive(:create).once.with(sensor_data: 2)

      subject.call(sensors_data)
      subject.call(sensors_data_2)
    end
  end

  it "does not save the same data" do
    expect(HolodilnicSensorsData).to receive(:create).once.with(sensor_data: 1)

    subject.call(sensors_data)
    subject.call(sensors_data)
  end

  it "transform keys" do
    expect(HolodilnicSensorsData).to receive(:create).once.with(transformed_sensors_data)

    subject.call(real_sensors_data)
  end
end
