class AddStudyDateToSpm < ActiveRecord::Migration[6.0]
  def change
    add_column :spms, :study_date, :date
  end
end
