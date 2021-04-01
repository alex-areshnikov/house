module Datastorage
  class Destroyer
    DESTROYERS = {
      keep_1_day_logs: ->() { ::HouseLog.older_than_x_days(1).destroy_all },
    }

    def initialize(target_object)
      @target_object = target_object
    end

    def destroy
      DESTROYERS.fetch(target_object).call
    end

    private

    attr_reader :target_object
  end
end
