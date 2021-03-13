class HouseLogChannel < ApplicationCable::Channel
  def subscribed
    stream_from "house_log_channel"
  end
end
