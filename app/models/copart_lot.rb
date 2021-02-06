class CopartLot < ApplicationRecord
  include AASM

  validates :lot_number, presence: true, uniqueness: true

  aasm do
    state :initialized, initial: true
    state :scan_requested
    state :scanning
    state :scanned
    state :auction_requested
    state :auction_joined

    event :scan do
      transitions from: [:initialized, :scanned, :scan_requested],to: :scan_requested
    end

    event :scan_start do
      transitions from: :scan_requested, to: :scanning
    end

    event :scan_complete do
      transitions from: :scanning, to: :scanned
    end
  end
end
