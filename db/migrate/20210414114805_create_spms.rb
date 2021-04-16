class CreateSpms < ActiveRecord::Migration[6.0]
  def change
    create_table :spms do |t|
      t.belongs_to :patient, null: false, foreign_key: true
      t.string :spm_base
      t.string :spm_mirror

      t.timestamps
    end
  end
end
