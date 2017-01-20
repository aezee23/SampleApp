class AddUserIdToChurchGroups < ActiveRecord::Migration
  def change
    add_column :church_groups, :user_id, :integer
  end
  
end
