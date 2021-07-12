class AddDescriptionToPhotos < ActiveRecord::Migration[6.1]
  def change
    add_column :photos, :description, :text
  end
end
