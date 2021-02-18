module Copart
  class LotsPage
    PER_PAGE = 10

    def initialize(page, ransack_query)
      @page = page
      @ransack_query = ransack_query
    end

    def lots_ransack
      copart_lot_base_relation = ransack_query.present? ? ::CopartLot : ::CopartLot.scheduled_or_future
      copart_lot_base_relation.order(:sale_date, :created_at).ransack(ransack_query)
    end

    def lots
      lots_ransack.result.page(page).per(PER_PAGE)
    end

    def decorated_lots
      lots.map { ::Copart::LotDecorator.new(_1) }
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

      [nil] + ::CopartLot.distinct(:model).where(make: ransack_query["make_eq"]).order(:model).pluck(:model).compact
    end

    private

    attr_reader :page, :ransack_query

    def available(field)
      [nil] + ::CopartLot.distinct(field).order(field).pluck(field).compact
    end
  end
end
