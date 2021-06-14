class Vehicle < ApplicationRecord
  has_many :photos, as: :owner
  has_one :copart_lot
end
