module Vehicles
  class SelectedPhotosProcessor
    ACTION_PROCESSORS = {
      "Delete Selected" => ->(owner, selected_photo_ids) { ::Datastorage::Destroyers::Photos.new(owner, selected_photo_ids).call },
      "Rename Selected" => ->(_, _) { },
      "Move Selected" => ->(_, _) { }
    }

    def initialize(owner:, action_text:, selected_photo_ids:)
      @owner = owner
      @action_text = action_text
      @selected_photo_ids = selected_photo_ids
    end

    def call
      ACTION_PROCESSORS.fetch(action_text).call(owner, selected_photo_ids)
    end

    private

    attr_reader :owner, :action_text, :selected_photo_ids
  end
end
