class RemoveIsLeaderFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :is_leader
  end
end
