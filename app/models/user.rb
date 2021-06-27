class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :recoverable,  :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :registerable, :validatable
end
