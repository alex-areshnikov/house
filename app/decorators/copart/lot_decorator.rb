module Copart
  class LotDecorator
    include ActionView::Helpers::DateHelper
    delegate :id, :lot_number, :name, :vin, :primary_damage, :secondary_damage, :sale_date, :aasm, to: :lot

    FUTURE = "Future".freeze

    def initialize(lot)
      @lot = lot
    end

    def photo_thumb_url
      return unless photos?

      lot.copart_lot_photos.first.photo.thumb.url
    end

    def photos?
      lot.copart_lot_photos.exists?
    end

    def photo_urls
      lot.copart_lot_photos.map(&:photo_url)
    end

    def state_text
      aasm.current_state.to_s.humanize
    end

    def damage
      [lot.primary_damage, lot.secondary_damage].reject(&:blank?).join(" / ")
    end

    def sale_date_text
      return if name.blank?
      return FUTURE if sale_date.blank?

      "#{sale_date} (#{distance_of_time_in_words(DateTime.current, sale_date)}#{" ago" if sale_date_past?})"
    end

    def sale_date_text_class
      return "text-success" if sale_date_today?

      sale_date_past? ? "text-danger" : "text-secondary"
    end

    private

    attr_reader :lot

    def sale_date_past?
      return false if sale_date.blank?

      sale_date < DateTime.current
    end

    def sale_date_today?
      return false if sale_date.blank?

      sale_date.to_date == Date.current
    end
  end
end
