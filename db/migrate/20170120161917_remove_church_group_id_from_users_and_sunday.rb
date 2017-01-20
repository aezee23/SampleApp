class RemoveChurchGroupIdFromUsersAndSunday < ActiveRecord::Migration
  def change
    remove_column :users, :sunday_meeting
    remove_column :users, :church_group_id
    remove_column :users, :city
  end
end
