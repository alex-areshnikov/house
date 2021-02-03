module Copart
  class DataResolverFactory
    COMMUNICATOR_RESOLVERS = {
      "lot_scanner" => ::Copart::ScannerDataLoader,
      "logger" => "" # TODO: implement me
    }

    def self.for_communicator(data)
      COMMUNICATOR_RESOLVERS.fetch(data["communicator"], ::Copart::BadIncomingDataResolver).new(data)
    end
  end
end
