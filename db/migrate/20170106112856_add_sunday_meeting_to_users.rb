class AddSundayMeetingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sunday_meeting, :boolean
  end
end
