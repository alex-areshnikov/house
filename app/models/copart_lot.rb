class CopartLot < ApplicationRecord
  include AASM

  has_many :copart_lot_photos, dependent: :destroy

  validates :lot_number, presence: true, uniqueness: true

  scope :past, ->{ where("sale_date < ?", DateTime.current) }
  scope :future, ->{ where(sale_date: nil) }
  scope :scheduled, ->{ where("sale_date >= ?", DateTime.current) }
  scope :scheduled_or_future, ->{ scheduled.or(future) }

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

  def self.ransackable_scopes(_)
    %w(scheduled_or_future)
  end
end
