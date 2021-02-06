class CreateHouseLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :house_logs do |t|
      t.string :level
      t.string :source
      t.text :description

      t.timestamps
    end
  end
end
