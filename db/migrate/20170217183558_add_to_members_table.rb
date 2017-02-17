class AddToMembersTable < ActiveRecord::Migration
  def change
    add_column :members, :church_id, :integer
    add_column :members, :church_group_id, :integer
    add_column :members, :name, :string
    add_column :members, :email, :string
    add_column :members, :avatar, :string
    add_column :members, :phone_number, :string
  end
end
