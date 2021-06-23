class AddPurchasedToCopartLots < ActiveRecord::Migration[6.1]
  def change
    add_column :copart_lots, :purchased, :boolean, default: false
  end
end
