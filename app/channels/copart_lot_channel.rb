class CopartLotChannel < ApplicationCable::Channel
  def subscribed
    stream_from "copart_lot_channel"
  end
end
