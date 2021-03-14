module Copart
  module Resolvers
    class LotPhotosLoader
      def initialize(data)
        @data = data
      end

      def call
        return unless data["photo_urls"].present?

        photo_urls = JSON.parse(data["photo_urls"])
        ::Copart::PhotosSaver.new(data["lot_number"], photo_urls.compact).call
      end

      private

      attr_reader :data
    end
  end
end
