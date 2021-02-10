class HouseNodeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "house_node_channel"
  end
end
