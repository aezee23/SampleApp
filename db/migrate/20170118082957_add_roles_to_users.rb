class AddRolesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, default: "Elder"
  end
end
