module Copart
  class DataResolverFactory
    COMMUNICATOR_RESOLVERS = {
      "lot_scanner" => ::Copart::Resolvers::ScannerDataLoader,
      "photos_collector" => ::Copart::Resolvers::LotPhotosLoader,
      "logger" => ::Copart::Resolvers::LoggerResolver
    }

    def self.for_communicator(data)
      COMMUNICATOR_RESOLVERS.fetch(data["communicator"], ::Copart::Resolvers::BadIncomingDataResolver).new(data)
    end
  end
end
