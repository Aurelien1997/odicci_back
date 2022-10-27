class User < ApplicationRecord
    validates :first_name,:last_name, :email, :phone, :birth, presence: true, uniqueness: true
end
