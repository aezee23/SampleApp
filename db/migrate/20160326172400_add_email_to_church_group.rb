class AddEmailToChurchGroup < ActiveRecord::Migration
  def change
    add_column :church_groups, :email, :string
  end
end
