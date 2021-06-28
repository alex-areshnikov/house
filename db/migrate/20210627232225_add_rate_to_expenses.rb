class AddRateToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :rate, :decimal, precision: 10, scale: 5, default: 1.0, null: false
  end
end
