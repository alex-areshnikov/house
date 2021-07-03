class Vehicle < ApplicationRecord
  has_many :photos, as: :owner, dependent: :destroy
  has_many :folders, as: :owner, dependent: :destroy
  has_many :expenses, as: :owner, dependent: :destroy
  has_one :copart_lot
end
