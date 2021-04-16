class Spm < ApplicationRecord

  # validates :npp, presence: true
  # validates :npp, length: { is: 12 }
  # validates :npp, uniqueness: true
  validates :spm_base, :study_date, presence: :true
  belongs_to :patient

end
