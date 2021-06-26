class AddCategoryToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :category, :string, default: "", null: false
  end
end
