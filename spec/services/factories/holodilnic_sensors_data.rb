# frozen_string_literal: true
FactoryBot.define do
  factory :holodilnic_sensors_data do
    humidity_top { 45.2 }
    temperature_top_c { 25.8 }
    humidity_bottom { 43.2 }
    temperature_bottom_c { 24.6 }
  end
end
