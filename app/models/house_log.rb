class HouseLog < ApplicationRecord
  mount_uploader :screenshot, ::HouseLogScreenshotUploader

  scope :older_than_x_days, ->(days) { where("created_at <= ?", Date.current - days.days) }
end
