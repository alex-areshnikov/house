# frozen_string_literal: true
require "rails_helper"

describe ::Holodilnic::MqttListener do
  subject { described_class.new }

  let(:mqtt_client) { instance_double(MQTT::Client) }

  it "exists" do
    expect(MQTT::Client).to receive(:connect).and_return(Proc.new {})

    subject.call
  end
end
