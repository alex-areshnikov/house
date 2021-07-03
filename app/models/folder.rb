class Folder < ApplicationRecord
  belongs_to :owner, polymorphic: true

  has_many :photos, as: :owner, dependent: :destroy
  has_many :folders, as: :owner, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :owner }
end
