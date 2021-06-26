class AddCurrencyToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :currency, :string, default: :USD, null: false
  end
end
