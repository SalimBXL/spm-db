class ChangeColumnNameNppToPatientId < ActiveRecord::Migration[6.0]
  def change
    rename_column :spms, :npp, :patient_id
  end
end
