class RemoveElderFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :elder
  end
end
