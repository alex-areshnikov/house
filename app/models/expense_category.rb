class ExpenseCategory < ApplicationRecord
  validates :name, presence: true
end
