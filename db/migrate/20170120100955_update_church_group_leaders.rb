class UpdateChurchGroupLeaders < ActiveRecord::Migration
  def change
  end
  ChurchGroup.find_by_name("Matthew").update_column(:user_id, User.find_by_elder("Danniella Hart"))
  User.where(is_leader: true).destroy_all
  ChurchGroup.find_by_name("Admin Team").destroy

end
