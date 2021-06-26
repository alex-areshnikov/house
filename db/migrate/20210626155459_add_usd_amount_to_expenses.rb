class AddUsdAmountToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :usd_amount, :decimal, precision: 10, scale: 2
  end
end
