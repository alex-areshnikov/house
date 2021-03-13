class AddScreenshotToHouseLogs < ActiveRecord::Migration[6.1]
  def change
    add_column :house_logs, :screenshot, :string
  end
end
