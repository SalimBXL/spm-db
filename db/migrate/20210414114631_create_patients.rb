class CreatePatients < ActiveRecord::Migration[6.0]
  def change
    create_table :patients do |t|
      t.string :fullname
      t.string :npp

      t.timestamps
    end
  end
end
