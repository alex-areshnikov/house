module Datastorage
  class Destroyer
    DESTROYERS = {
      keep_1_day_logs: ->(_) { ::HouseLog.older_than_x_days(1).destroy_all },
      photos: ->(owner) { ::Photo.where(owner: owner).destroy_all },
    }

    def initialize(target_object)
      @target_object = target_object
    end

    def destroy(entity = nil)
      DESTROYERS.fetch(target_object).call(entity)
    end

    private

    attr_reader :target_object
  end
end
