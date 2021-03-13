module Copart
  class DataResolverFactory
    COMMUNICATOR_RESOLVERS = {
      "lot_scanner" => ::Copart::Resolvers::ScannerDataLoader,
      "photos_collector" => ::Copart::Resolvers::LotPhotosLoader,
      "logger" => ::Copart::Resolvers::LoggerResolver
    }

    def self.for_communicator(data)
      communicator = data.delete("communicator")
      COMMUNICATOR_RESOLVERS.fetch(communicator, ::Copart::Resolvers::BadIncomingDataResolver).new(data)
    end
  end
end
