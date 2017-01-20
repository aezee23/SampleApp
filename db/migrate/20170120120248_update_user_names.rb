class UpdateUserNames < ActiveRecord::Migration
  def change
  end
  User.all.each { |user| user.update_column(:name, user.elder) }
end
