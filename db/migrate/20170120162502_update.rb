class Update < ActiveRecord::Migration
  def change
  end
  User.find(32).update_column(:name, "Jane Hyde")
  User.find(31).update_column(:name, "Jean Kabasomi")
  User.find(31).update_column(:role, "Overseer")
  User.find(30).update_column(:name, "Andy")
  User.find(30).update_column(:name, "Andy")
  User.find(34).update_column(:name, "Bishop Richard")
  ChurchGroup.find_by_name("London Main").update_column(:user_id, User.find_by_name("Maureen Lutalo").id)
end
