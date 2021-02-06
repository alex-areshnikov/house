module Copart
  class LoggerResolver
    def initialize(data)
      @data = data["data"]
    end

    def call
      ::Datastorage::Creator.new(:house_log, attributes).create
    end

    private

    def attributes
      {
        level: data["level"],
        source: data["source"],
        description: [data["error"], data["message"], data["stack"]].compact.join("\n\n")
      }
    end

    attr_reader :data
  end
end
