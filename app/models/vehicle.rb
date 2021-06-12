class Vehicle < ApplicationRecord
  has_many :photos, as: :owner
end
