module Copart
  class LotDecorator
    include ActionView::Helpers::DateHelper
    delegate :id, :lot_number, :name, :vin, :primary_damage, :secondary_damage, :sale_date, :aasm, to: :lot

    FUTURE = "Future".freeze

    def initialize(lot)
      @lot = lot
    end

    def state_text
      aasm.current_state.to_s.humanize
    end

    def sale_date_text
      return if name.blank?
      return FUTURE if sale_date.blank?

      "#{sale_date} (#{distance_of_time_in_words(Time.current, sale_date)})"
    end

    private

    attr_reader :lot
  end
end
