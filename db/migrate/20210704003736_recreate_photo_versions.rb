class Photo < ApplicationRecord
  mount_uploader :photo, ::PhotoUploader
end

class RecreatePhotoVersions < ActiveRecord::Migration[6.1]
  def up
    Photo.find_each.each do |photo|
      photo.photo.recreate_versions!
    end
  end

  def down
    # Do nothing
  end
end
