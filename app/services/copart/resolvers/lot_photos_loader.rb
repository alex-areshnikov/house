module Copart
  module Resolvers
    class LotPhotosLoader
      def initialize(data)
        @data = data["data"]
      end

      def call
        ::Copart::PhotosSaver.new(data["lot_number"], data["photo_urls"].compact).call if data["photo_urls"].present?
      end

      private

      attr_reader :data
    end
  end
end
