class DeleteLeaderFromChurchGroups < ActiveRecord::Migration
  def change
    remove_column :church_groups, :leader
  end
end
