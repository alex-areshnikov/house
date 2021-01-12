class AddAasmStateToCopartLot < ActiveRecord::Migration[6.1]
  def change
    add_column :copart_lots, :aasm_state, :string
  end
end
