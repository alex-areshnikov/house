class CopartLot < ApplicationRecord
  include AASM

  validates :lot_number, presence: true, uniqueness: true

  aasm do
    state :initialized, initial: true
    state :processing
    state :processed

    event :reset do
      transitions to: :initialized
    end

    event :process do
      transitions to: :processing
    end

    event :complete_process do
      transitions from: :processing, to: :processed
    end
  end
end
