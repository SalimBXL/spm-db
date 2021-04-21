class Setting < ApplicationRecord
    validates :key, presence: true
    validates :key, uniqueness: true
    validates :value, presence: true
end
