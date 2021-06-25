class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.text :description
      t.references :owner, polymorphic: true
      t.string :expense_type, default: "debit"
      t.boolean :refundable, default: false
      t.boolean :refunded, default: false

      t.timestamps
    end
  end
end
