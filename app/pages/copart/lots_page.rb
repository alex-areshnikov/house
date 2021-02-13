module Copart
  class LotsPage
    def lots
      ::CopartLot.order(:sale_date, :created_at)
    end

    def decorated_lots
      lots.map { ::Copart::LotDecorator.new(_1) }
    end
  end
end
