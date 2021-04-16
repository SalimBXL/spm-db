class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :spms, :patient_id, :npp
  end
end
