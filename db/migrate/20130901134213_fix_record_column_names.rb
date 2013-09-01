class FixRecordColumnNames < ActiveRecord::Migration
  def change
    rename_column :records, :start, :start_time
    rename_column :records, :end, :end_time
  end
end
