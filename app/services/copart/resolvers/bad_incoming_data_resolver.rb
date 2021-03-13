module Copart
  module Resolvers
    class BadIncomingDataResolver
      def initialize(data)
        @data = data
      end

      def call
        ::Datastorage::Creator.new(:house_log, attributes).create
      end

      private

      def attributes
        {
          level: "error",
          source: "incoming-data-resolver",
          description: "Bad incoming data: #{data}"
        }
      end

      attr_reader :data
    end
  end
end
