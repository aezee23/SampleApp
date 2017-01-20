class AddUniqueChurchRecordIndex < ActiveRecord::Migration
  def change
    add_index :records, [:day, :church_id], unique: true
  end
end
