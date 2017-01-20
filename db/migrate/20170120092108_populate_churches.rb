class PopulateChurches < ActiveRecord::Migration
  def change
  end
  User.where(admin: false, is_leader: false).each do |user|
    Church.create(user_id: user.id, 
      church_group_id: user.church_group_id,
      name: user.name,
      short_name: user.name.gsub(" ", "")[0..2].upcase,
      date_started: "2016-01-01",
      email: user.email,
      city: user.city,
      sunday_meeting: user.sunday_meeting
      )
  end
end
