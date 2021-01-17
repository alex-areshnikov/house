class CopartLotChannel < ApplicationCable::Channel
  def subscribed
    stream_from "copart_lot_channel", ->(data) { ::Copart::ScannerDataLoader.new(data).call }, coder: ActiveSupport::JSON
  end

  def receive(data)
    puts "DATA: #{data}"
  end
end
