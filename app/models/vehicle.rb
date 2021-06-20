class Vehicle < ApplicationRecord
  has_many :photos, as: :owner, dependent: :destroy
  has_one :copart_lot
end
