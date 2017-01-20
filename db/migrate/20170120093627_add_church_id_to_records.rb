class AddChurchIdToRecords < ActiveRecord::Migration
  def change
    add_column :records, :church_id, :integer
  end
end
