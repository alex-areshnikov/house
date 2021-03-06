module Copart
  class LotDecorator
    include ActionView::Helpers::DateHelper
    delegate :id, :lot_number, :primary_damage, :secondary_damage, :sale_date, :doc_type,
             :location, :purchased, :aasm, to: :lot

    delegate :name, :vin, :odometer, :engine_type, :photos, to: :vehicle

    FUTURE = "Future".freeze

    def initialize(lot)
      @lot = lot
      @vehicle = lot.vehicle
    end

    def photo_thumb_url
      return unless photos?

      photos.first.photo.thumb.url
    end

    def expense_categories
      vehicle.expenses.order(:category).pluck(:category).uniq
    end

    def decorated_expenses_by_category(category)
      expenses.where(category: category).map { ::Vehicles::ExpenseDecorator.new(_1) }
    end

    def expenses
      vehicle.expenses.default_order
    end

    def expenses?
      expenses.exists?
    end

    def photos?
      photos.exists?
    end

    def photo_urls
      photos.map(&:photo_url)
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

    def vehicle_id
      vehicle.id
    end

    private

    attr_reader :lot, :vehicle

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
