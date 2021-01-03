class CopartLot < ApplicationRecord
  validates :lot_number, presence: true, uniqueness: true
end
