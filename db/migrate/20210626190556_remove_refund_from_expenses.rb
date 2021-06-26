class RemoveRefundFromExpenses < ActiveRecord::Migration[6.1]
  def change
    remove_column :expenses, :refundable
    remove_column :expenses, :refunded
  end
end
