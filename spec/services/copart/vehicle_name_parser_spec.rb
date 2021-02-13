# frozen_string_literal: true
require "rails_helper"

describe ::Copart::VehicleNameParser do
  subject { described_class.new(vehicle_name).call }

  context "when valid vehicle name" do
    let(:vehicle_name) { "1984 Mercedes-benz 330 Diesel" }

    its(:year) { is_expected.to eq("1984") }
    its(:make) { is_expected.to eq("Mercedes-benz") }
    its(:model) { is_expected.to eq("330 Diesel") }
  end

  context "when invalid vehicle name" do
    let(:vehicle_name) { "invalid vehicle-name" }

    its(:year) { is_expected.to be nil }
    its(:make) { is_expected.to be nil }
    its(:model) { is_expected.to be nil }
  end

  context "when nil vehicle name" do
    let(:vehicle_name) { nil }

    its(:year) { is_expected.to be nil }
    its(:make) { is_expected.to be nil }
    its(:model) { is_expected.to be nil }
  end
end
