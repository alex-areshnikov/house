class CopartLotChannel < ApplicationCable::Channel
  def subscribed
    stream_from "copart_lot_channel"
  end

  def receive(data)
    puts "HERE!!"
    ::Copart::DataResolverFactory.for_communicator(data).call
  end
end
