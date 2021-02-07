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

      "#{sale_date} (#{distance_of_time_in_words(Time.current, sale_date)})"
    end

    private

    attr_reader :lot
  end
end
