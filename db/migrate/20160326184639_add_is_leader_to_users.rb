class AddIsLeaderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_leader, :boolean
  end
end
