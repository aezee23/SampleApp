class AddUniqueToRecords < ActiveRecord::Migration
  def change
  	remove_index :records, :day
  end
end
