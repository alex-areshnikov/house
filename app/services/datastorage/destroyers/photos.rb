module Datastorage
  module Destroyers
    class Photos
      def initialize(owner, photo_ids)
        @owner = owner
        @photo_ids = photo_ids
      end

      def call
        ::Photo.where(owner: owner, id: photo_ids).destroy_all
      end

      private

      attr_reader :owner, :photo_ids
    end
  end
end
