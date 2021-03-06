module Copart
  class LotsPage
    PER_PAGE = 10

    attr_reader :page, :ransack_query

    def initialize(page, ransack_query, purchased)
      @page = page
      @ransack_query = ransack_query
      @purchased = purchased
    end

    def lots_ransack
      copart_lot_base_relation = ransack_query.present? ? ::CopartLot.scanned : ::CopartLot.scanned.scheduled_or_future
      copart_lot_base_relation.order(:sale_date, :created_at).ransack(ransack_query)
    end

    def lots
      relation = (purchased? ? ::CopartLot.purchased : lots_ransack.result)
      relation.page(page).per(PER_PAGE)
    end

    def main_lots
      lots.map { ::Copart::LotDecorator.new(_1) }
    end

    def lot_numbers_awaiting_scan
      ::CopartLot.added.pluck(:lot_number).join(", ")
    end

    def lot_numbers_scanning
      ::CopartLot.scanning.pluck(:lot_number).join(", ")
    end

    def lot_numbers_erred
      ::CopartLot.erred.pluck(:lot_number).join(", ")
    end

    def purchased?
      purchased.present?
    end

    def info_card?
      scanning? || awaiting_scan?
    end

    def error_card?
      ::CopartLot.erred.exists?
    end

    def scanning?
      ::CopartLot.scanning.exists?
    end

    def awaiting_scan?
      ::CopartLot.added.exists?
    end

    def available_years
      available(:year)
    end

    def available_makes
      available(:make)
    end

    def hide_past?
      ransack_query.blank? || ransack_query["scheduled_or_future"].present?
    end

    def available_models
      return [nil] if ransack_query.nil? || ransack_query["make_eq"].blank?

      [nil] + ::Vehicle.distinct(:model).where(make: ransack_query["make_eq"]).order(:model).pluck(:model).compact
    end

    def actions
      purchased ? %i[show_lot show_photos] : %i[watch_auction scan_lot show_photos edit_lot delete_lot]
    end

    private

    attr_reader :purchased

    def available(field)
      [nil] + ::Vehicle.distinct(field).order(field).pluck(field).compact
    end
  end
end
