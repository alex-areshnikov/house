class CopartLot < ApplicationRecord
  AUCTION_DURATION_HOURS = 4.hours

  include AASM

  has_many :copart_lot_photos, dependent: :destroy

  validates :lot_number, presence: true, uniqueness: true

  scope :past, ->{ where("sale_date < ?", DateTime.current - AUCTION_DURATION_HOURS) }
  scope :future, ->{ where(sale_date: nil) }
  scope :scheduled, ->{ where("sale_date >= ?", DateTime.current - AUCTION_DURATION_HOURS) }
  scope :scheduled_or_future, ->{ scheduled.or(future) }
  scope :added, ->{ where(aasm_state: [:initialized, :scan_requested]) }
  scope :scanning, ->{ where(aasm_state: :scanning) }
  scope :erred, ->{ where(aasm_state: :erred) }
  scope :scanned, ->{ where.not(aasm_state: [:initialized, :scan_requested, :scanning]) }
  scope :updated_more_than_x_minutes, ->(minutes){ where("updated_at < ?", Time.current - minutes.minutes)}

  aasm do
    state :initialized, initial: true
    state :scan_requested
    state :scanning
    state :scanned
    state :erred

    event :scan do
      transitions from: [:initialized, :scanned, :scan_requested], to: :scan_requested
    end

    event :scan_start do
      transitions from: :scan_requested, to: :scanning
    end

    event :scan_complete do
      transitions from: :scanning, to: :scanned
    end

    event :error do
      transitions to: :erred
    end

    event :reset do
      transitions to: :initialized
    end
  end

  def self.ransackable_scopes(_)
    %w(scheduled_or_future)
  end
end
