class CreateChurches < ActiveRecord::Migration
  def change
    create_table :churches do |t|
      t.integer :user_id
      t.integer :church_group_id
      t.string :name
      t.string :short_name
      t.string :email
      t.string :city
      t.string :postcode
      t.string :address
      t.date :date_started
      t.boolean :sunday_meeting
      t.timestamps
    end
  end
end
