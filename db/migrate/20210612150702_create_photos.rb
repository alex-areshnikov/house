class CreatePhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :photos do |t|
      t.string :owner_type
      t.bigint :owner_id
      t.string :photo

      t.timestamps
    end

    add_index :photos, [:owner_type, :owner_id]
  end
end
