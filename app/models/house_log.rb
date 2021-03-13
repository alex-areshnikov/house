class HouseLog < ApplicationRecord
  mount_uploader :screenshot, ::HouseLogScreenshotUploader
end
