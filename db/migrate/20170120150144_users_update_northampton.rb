class UsersUpdateNorthampton < ActiveRecord::Migration
  def change
  end
  User.find_by_name("Joycelyn Appiah").update_column(:name, "Esme Mantiziba")
end
