class AddNbsFinishToRecords < ActiveRecord::Migration
  def change
    add_column :records, :nbs_finish, :integer
  end
end
