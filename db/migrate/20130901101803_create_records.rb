class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.datetime :start
      t.datetime :end
      t.references :student, index: true

      t.timestamps
    end
  end
end
