module Copart
  module Resolvers
    class LoggerResolver
      def initialize(data)
        @data = data
      end

      def call
        log = ::Datastorage::Creator.new(:house_log, attributes).create
        ::ActionCable.server.broadcast("house_log_channel", ::LogsPage.new.log_row(log))
      end

      private

      def attributes
        {
          level: data["level"],
          source: data["source"],
          description: [data["error"], data["message"], data["stack"]].compact.join("\n\n"),
          screenshot: data["file"]
        }
      end

      attr_reader :data
    end
  end
end
