class AddUniqueIndex < ActiveRecord::Migration
  def change
  	add_index :records, [:day, :user_id], unique: true
  end
end
