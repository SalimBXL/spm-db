class Patient < ApplicationRecord
    validates :fullname, presence: true
    validates :npp, presence: true
    validates :npp, length: { is: 10 }
    validates :npp, uniqueness: true
    has_many :spms, dependent: :destroy
    validates_associated :spms
end
