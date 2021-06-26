class Expense < ApplicationRecord
  extend Enumerize

  belongs_to :owner, polymorphic: true

  validates :amount, numericality: { greater_than: 0 }
  validates :description, presence: true

  enumerize :expense_type, in: [:debit, :credit]
  enumerize :currency, in: [:USD, :EUR, :BYN]

  scope :debit, ->{ where(expense_type: :debit) }
  scope :credit, ->{ where(expense_type: :credit) }

  scope :default_order, -> { order(created_at: :asc) }
end
