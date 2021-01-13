class CopartLotChannel < ApplicationCable::Channel
  def subscribed
    stream_from "copart_lot_channel", ->(data) { puts data["body"] }, coder: ActiveSupport::JSON
  end

  def receive(data)
    puts "DATA: #{data}"
  end
end
