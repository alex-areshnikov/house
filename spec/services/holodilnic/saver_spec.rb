# frozen_string_literal: true
require "rails_helper"

describe ::Holodilnic::Saver do
  include ActiveSupport::Testing::TimeHelpers
  subject { described_class.new }

  let(:sensors_data) { { sensor_data: 1 } }
  let(:sensors_data_2) { { sensor_data: 2 } }

  it "saves changed data" do
    travel_to Date.new(2010, 5, 20) do
      expect(HolodilnicSensorsData).to receive(:create).once.with(sensor_data: 1)
      expect(HolodilnicSensorsData).to receive(:create).once.with(sensor_data: 1, created_at: Time.current - 5.seconds)
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
end
